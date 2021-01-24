using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace AssemblerProgram
{
    public class Assembler
    {
        Dictionary<string, int> labelAddress;
        List<string> hexInstructions;
        List<string> assemblyInstructions;
        int address;
        string opCode = "";
        string opCodeEx = "";
        string immediate = "";
        string cond = "";
        string rSrc = "";
        string rDst = "";
        string label = "";
        bool isAluOrMem = false;
        bool isLoad = false;
        bool isStor = false;
        bool isImm = false;
        bool isBranch = false;
        bool isJcond = false;
        bool isJal = false;
        bool isUncond = false;
        int JCount = 0;



        public Assembler(string filename)
        {
            labelAddress = new Dictionary<string, int>();
            hexInstructions = new List<string>();
            assemblyInstructions = new List<string>();
            address = 0;
            ReadFile(filename);
        }

        private void ReadFile(string filename)
        {
            string line;

            // Read the file and display it line by line.  
            System.IO.StreamReader file = new System.IO.StreamReader(filename);
            while ((line = file.ReadLine()) != null)
            {
                assemblyInstructions.Add(line);
            }
            file.Dispose();
        }
        /// <summary>
        /// First pass that will loop through and store lables and calculate based on the number of jumps 
        /// there are 
        /// </summary>
        public void ConvertAssemblyFirstPass()
        {
            int counter = 0;
            foreach (string instruction in assemblyInstructions)
            {
                string Instruction = instruction.Replace(",", "");
                string[] tokens = Regex.Split(Instruction, @"\s+|/+");//split instruction to read 
                foreach (string item in tokens)
                {
                    if (item.Equals("JEQ") || item.Equals("JGT") || item.Equals("JLT") || item.Equals("JNE"))//if it is a jump make sure to calculate 
                    {
                        counter++;
                    }
                    if (Regex.IsMatch(item, @"\w+\:"))//if it is a label store it in a dictionary 
                    {
                        labelAddress.Add(item.Replace(":", ""), address + (counter * 2));
                    }

                }
                address++;
            }
        }
        /// <summary>
        /// second pass that will loop through each instruction and convert it to binary 
        /// </summary>
        public void ConvertAssembly()
        {
            address = 0;
            foreach (string instruction in assemblyInstructions)
            {
                //start up variables for use in the process 
                label = "";
                opCode = "";
                opCodeEx = "";
                immediate = "";
                rSrc = "";
                rDst = "";
                bool Rdest = false;
                bool Rsrc = false;
                bool gotLabel = false;
                isAluOrMem = false;
                isBranch = false;
                isJcond = false;
                isImm = false;
                isJal = false;
                isUncond = false;
                isStor = false;
                isLoad = false;
                string Instruction = instruction.Replace(",", "");
                string[] tokens = Regex.Split(Instruction, @"\s+|/+");//split the instrucitons into tokens 
                foreach (string item in tokens)
                {
                    // if statementa for the actual conversion to binary
                    Operation(item);
                    if (labelAddress.ContainsKey(item) && (gotLabel == false))//if it is a label  then store it for later 
                    {
                        label = item;
                        gotLabel = true;
                    }
                    if (Regex.IsMatch(item, @"\$\d+"))//if it is a register then check which on e
                    {
                        string registerNumber = item.Replace("$", "");
                        int regNumber = int.Parse(registerNumber);

                        if (!Rsrc)//if source then convert it to hex 
                        {
                            rSrc = Convert.ToString(regNumber, 2).PadLeft(4, '0');
                            Rsrc = true;
                        }
                        else if (!Rdest)// if desitnation, then conver it to hex 
                        {
                            rDst = Convert.ToString(regNumber, 2).PadLeft(4, '0');
                            Rdest = true;
                        }

                    }
                    else if (int.TryParse(item, out int result))// if it is an immediate then convert it 
                    {
                        if (result >= 0)//if it is greater than convert it 
                        {
                            immediate = Convert.ToString(result, 2).PadLeft(8, '0');
                        }
                        else if (result < 0)//if less than then we have to get rid of the extra 1's 
                        {
                            string twoComplement = Convert.ToString(result, 2);//get the twos complement 
                            immediate = "";
                            for (int i = 24; i < twoComplement.Length; i++)
                            {
                                immediate += twoComplement[i];
                            }
                        }
                        Rsrc = true;
                    }
                }
                if (isStor || isLoad)//if we have a load or store operation then convert it to hex 
                {
                    string storInstruction = opCode + rSrc + opCodeEx + rDst;//append for the instructions 
                    string hex = Convert.ToInt32(storInstruction, 2).ToString("X").PadLeft(4, '0');
                    hexInstructions.Add(hex);
                }
                if (isAluOrMem)// for the alu instructions, jal, stor, load, lsh
                {
                    string aluInstruction = opCode + rDst + opCodeEx + rSrc; // the instruction in binary 
                    string hex = Convert.ToInt32(aluInstruction, 2).ToString("X").PadLeft(4, '0');//convert to hex
                    hexInstructions.Add(hex);
                }
                if (isImm)//for instructions that use can an immediate value 
                {
                    string aluInstruction = opCode + rDst + immediate;//append the binary values 
                    string hex = Convert.ToInt32(aluInstruction, 2).ToString("X");
                    hexInstructions.Add(hex);
                }
                if (isBranch && gotLabel)// for branch instructions 
                {
                    string displacement = "";
                    int jumpAddress = labelAddress[label];
                    int displace = 0;
                    if (jumpAddress > address)//check if jump address is greater than current 
                    {
                        displace = jumpAddress - (address + 1);//get the displace ment 
                        string binary = Convert.ToString(displace, 2).PadLeft(16, '0');//conver to binary 
                        displacement = binary.Substring((int)(binary.Length / 2), (int)(binary.Length / 2));//ge the actual 8 bits 
                    }
                    else if (address > jumpAddress)//if it is less than the current address 
                    {
                        displace = jumpAddress - (address + 1);//ge the displacement 
                        string binary = Convert.ToString(displace, 2);//convert it 
                        for (int i = 24; i < binary.Length; i++)
                        {
                            displacement += binary[i];
                        }
                    }
                    if (!(displace >= -128 && displace <= 128))//if out of these bounds then its an invalid branch 
                    {
                        throw new InvalidOperationException();
                    }

                    string branchIstruction = opCode + cond + displacement;//append the binary values 
                    string hex = Convert.ToInt32(branchIstruction, 2).ToString("X");
                    hexInstructions.Add(hex);
                }
                if (isJcond && gotLabel)//for the jump conditional instructions 
                {
                    string hex = "";
                    int Labaddress = 0;
                    //get the label address 
                    if (labelAddress[label] > address)
                    {
                        Labaddress = labelAddress[label]-1;
                    }
                    else
                    {
                        Labaddress = labelAddress[label] - 1;
                    }
                    string addr = Convert.ToString(Labaddress, 2).PadLeft(16, '0');//convert to 16 bit binary 
                    string upper = addr.Substring(0, (int)(addr.Length / 2));//get upper eight bits 
                    string lower = addr.Substring((int)(addr.Length / 2), (int)(addr.Length / 2));//get lower eight bits 
                    //from here we will split the jcond pseudo instruction into 3 instructions
                    string moviInstruction = "1101" + "1111" + lower;//move the lower 8 bits into the register 
                    string movi = Convert.ToInt32(moviInstruction, 2).ToString("X");//convet to hex 
                    hexInstructions.Add(movi);
                    address++;
                    string luiInstruction = "1111" + "1111" + upper;//move the upper 8 bits into the register 
                    string lui = Convert.ToInt32(luiInstruction, 2).ToString("X");//convert to hex 
                    hexInstructions.Add(lui);
                    address++;
                    string jumpCondInstruction = opCode + cond + opCodeEx + "1111";//append the binary values 
                    hex = Convert.ToInt32(jumpCondInstruction, 2).ToString("X");//convert to hex 
                    hexInstructions.Add(hex);
                }
                if (isJal && gotLabel)//if it is a JAL instruction 
                {
                    int address = labelAddress[label];//get the desired address of the label 
                    string addr = Convert.ToString(address, 2).PadLeft(16, '0');//convert it to hex 
                    string upper = addr.Substring(0, (int)(addr.Length / 2));//get the upper 8 bits 
                    string lower = addr.Substring((int)(addr.Length / 2), (int)(addr.Length / 2));//get lower 8 bits 
                    //from here we will split the jcond pseudo instruction into 3 instructions
                    string moviInstruction = "1101" + "1111" + lower;//move the lower 8 bits into the register 
                    string movi = Convert.ToInt32(moviInstruction, 2).ToString("X");
                    hexInstructions.Add(movi);
                    address++;
                    string luiInstruction = "1111" + "1111" + upper;//move the upper 8 bits into the register 
                    string lui = Convert.ToInt32(luiInstruction, 2).ToString("X");
                    hexInstructions.Add(lui);
                    address++;
                    string jumpCondInstruction = opCode + "1110" + opCodeEx + "1111";//append the binary values 
                    string hex = Convert.ToInt32(jumpCondInstruction, 2).ToString("X");
                    hexInstructions.Add(hex);
                }
                if (isUncond)
                {
                    string jumpCondInstruction = opCode + cond + opCodeEx + "1110";
                    string hex = Convert.ToInt32(jumpCondInstruction, 2).ToString("X");
                    hexInstructions.Add(hex);
                }
                address++;
            }
        }

        /// <summary>
        /// method that will check if the string is one of the operation 
        /// labels adn then set the opcode string and extension to the appropriate one 
        /// </summary>
        /// <param name="item"></param>
        private void Operation(string item)
        {
            //checks the string item if it is one of the operations and sets the opcode and 
            //extensions and booleans appropriately 
            if (item.Equals("ADD"))
            {
                opCode = "0000";
                opCodeEx = "0101";
                isAluOrMem = true;
            }
            else if (item.Equals("ADDI"))
            {
                opCode = "0101";
                isImm = true;
            }
            else if (item.Equals("ADDU"))
            {
                opCode = "0000";
                opCodeEx = "0110";
                isAluOrMem = true;
            }
            else if (item.Equals("ADDUI"))
            {
                opCode = "0110";
                isImm = true;
            }
            else if (item.Equals("MUL"))
            {
                opCode = "0000";
                opCodeEx = "1110";
                isAluOrMem = true;
            }
            else if (item.Equals("MULI"))
            {
                opCode = "1110";
                isImm = true;
            }
            else if (item.Equals("SUB"))
            {
                opCode = "0000";
                opCodeEx = "1001";
                isAluOrMem = true;
            }
            else if (item.Equals("SUBI"))
            {
                opCode = "1001";
                isImm = true;
            }
            else if (item.Equals("CMP"))
            {
                opCode = "0000";
                opCodeEx = "1011";
                isAluOrMem = true;
            }
            else if (item.Equals("CMPI"))
            {
                opCode = "1011";
                isImm = true;
            }
            else if (item.Equals("AND"))
            {
                opCode = "0000";
                opCodeEx = "0001";
                isAluOrMem = true;
            }
            else if (item.Equals("ANDI"))
            {
                opCode = "0001";
                isImm = true;
            }
            else if (item.Equals("OR"))
            {
                opCode = "0000";
                opCodeEx = "0010";
                isAluOrMem = true;
            }
            else if (item.Equals("ORI"))
            {
                opCode = "0010";
                isImm = true;
            }
            else if (item.Equals("XOR"))
            {
                opCode = "0000";
                opCodeEx = "0011";
                isAluOrMem = true;
            }
            else if (item.Equals("XORI"))
            {
                opCode = "0011";
                isImm = true;
            }
            else if (item.Equals("MOV"))
            {
                opCode = "0000";
                opCodeEx = "1101";
                isAluOrMem = true;
            }
            else if (item.Equals("MOVI"))
            {
                opCode = "1101";
                isImm = true;
            }
            else if (item.Equals("LOAD"))
            {
                opCode = "0100";
                opCodeEx = "0000";
                isLoad = true;
            }
            else if (item.Equals("STOR"))
            {
                opCode = "0100";
                opCodeEx = "0100";
                isStor = true;
            }
            else if (item.Equals("JAL"))
            {
                opCode = "0100";
                opCodeEx = "1000";
                isJal = true;
            }
            else if (item.Equals("LUI"))
            {
                opCode = "1111";
                isImm = true;
            }
            else if (item.Equals("LSH"))
            {
                opCode = "1000";
                opCodeEx = "0100";
                isAluOrMem = true;
            }
            else if (item.Equals("LSHI"))
            {
                opCode = "0100";
                opCodeEx = "1000";
            }
            else if (item.Equals("BEQ"))
            {
                opCode = "1100";
                cond = "0000";
                isBranch = true;
            }
            else if (item.Equals("BNE"))
            {
                opCode = "1100";
                cond = "0001";
                isBranch = true;
            }
            else if (item.Equals("BGE"))
            {
                opCode = "1100";
                cond = "1101";
                isBranch = true;
            }
            else if (item.Equals("BGT"))
            {
                opCode = "1100";
                cond = "0110";
                isBranch = true;
            }
            else if (item.Equals("BLE"))
            {
                opCode = "1100";
                cond = "0111";
                isBranch = true;
            }
            else if (item.Equals("BLT"))
            {
                opCode = "1100";
                cond = "1100";
                isBranch = true;
            }
            else if (item.Equals("JEQ"))
            {
                opCode = "0100";
                cond = "0000";
                opCodeEx = "1100";
                isJcond = true;
            }
            else if (item.Equals("JNE"))
            {
                opCode = "0100";
                cond = "0001";
                opCodeEx = "1100";
                isJcond = true;
            }
            else if (item.Equals("JGE"))
            {
                opCode = "0100";
                cond = "1101";
                opCodeEx = "1100";
                isJcond = true;
            }
            else if (item.Equals("JGT"))
            {
                opCode = "0100";
                cond = "0110";
                opCodeEx = "1100";
                isJcond = true;
            }
            else if (item.Equals("JLE"))
            {
                opCode = "0100";
                cond = "0111";
                opCodeEx = "1100";
                isJcond = true;
            }
            else if (item.Equals("JLT"))
            {
                opCode = "0100";
                cond = "1100";
                opCodeEx = "1100";
                isJcond = true;
            }
            else if (item.Equals("JUC"))
            {
                opCode = "0100";
                cond = "1110";
                opCodeEx = "1100";
                isJcond = true;
            }
        }
        /// <summary>
        /// returns all the hex instructons 
        /// </summary>
        /// <returns></returns>
        public List<string> GetListOfHexInstructions()
        {
            return hexInstructions;
        }
        /// <summary>
        /// returns the list of assembly instructions 
        /// </summary>
        /// <returns></returns>
        public List<string> GetListOfAssemblyInstructions()
        {
            return assemblyInstructions;
        }

        /// <summary>
        /// method to write to write hex instruction to the instruction.dat file 
        /// </summary>
        public void WriteHexInstrution()
        {
            
            //use stream writer 
            using (System.IO.StreamWriter file = new System.IO.StreamWriter("C:\\Users\\zahid\\OneDrive\\Documents\\CSECE 3710\\Processor\\instructions.dat"))
            {
                int count = 0;
                foreach (string instruction in GetListOfHexInstructions())//loop through and add 
                {
                    file.WriteLine(instruction);
                    count++;
                }
                for (int i = count; i < 64; i++)//add on extra zero to make quartus happy 
                {
                    file.WriteLine("0000");
                }
            }
        }
    }
}
