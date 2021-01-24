using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AssemblerProgram;


namespace AssemblerApplication1
{
    class AssemblerApplication
    {
        static void Main(string[] args)
        {
            Assembler assembler = new Assembler("test3.txt");//read the text file 
            foreach(string instruction in assembler.GetListOfAssemblyInstructions())
            {
                Console.WriteLine(instruction);
            }
            Console.WriteLine("-------------------------------");
            assembler.ConvertAssemblyFirstPass();//get the labels and counts jumps 
            assembler.ConvertAssembly();//second pass to convert 
            assembler.WriteHexInstrution();
            foreach (string instruction in assembler.GetListOfHexInstructions())
            {
                Console.WriteLine(instruction);
            }
            Console.ReadLine();
        }
    }
}
