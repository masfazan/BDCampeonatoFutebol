using System.Data;
using System.Data.SqlClient;
using System.Reflection.PortableExecutable;
using System.Runtime.ConstrainedExecution;
using CampeonatoFutebolBD;


internal class Program
{
    private static void Main(string[] args)
    {
        int opc = 0;
        do
        {
            Console.Clear();
            Console.WriteLine(" Menu  Principal ");
            Console.WriteLine("1 - Inserir time. ");
            Console.WriteLine("2 - Inserir partida. ");
            Console.WriteLine("3 - Inserir campeonato. ");
            //Console.WriteLine("4 - Inserir gol. ");
            //Console.WriteLine("5 - Atualizar pontuação. ");
            //Console.WriteLine("6 - Ver classificação. ");
            //Console.WriteLine("7 - Ver time com mais gols. ");
            //Console.WriteLine("8 - Ver time com menos gols. ");
            //Console.WriteLine("9 - Ver partida com mais gols. ");
            //Console.WriteLine("0 - Ver time campeão. ");
            //Console.WriteLine(" * - Sair ");
            //Console.Write("Opção desejada:  ");
            try
            {
                opc = Convert.ToInt32(Console.ReadLine());
                switch (opc)
                {
                    case 1:
                        //Inserir_Time();
                        break;
                    case 2:
                        //Inserir_Partida();
                        break;
                    case 3:
                        //Inserir_Campeonato();
                        break;
                    case 4:
                        //Inserir_Atualizar_Gol();
                        break;
                    case 5:
                        //Atualizar_Pontuacao();
                        break;
                    case 6:
                        //Obter_Classificacao();
                        break;
                    case 7:
                        //Time_Mais_Gols();
                        break;
                    case 8:
                        //Time_Menos_Gols();
                        break;
                    case 9:
                        //Partida_mais_gols();
                        break;
                    case 10:
                        //Obter_Campeao();
                        break;
                    default:
                        break;
                }
            }
            catch (Exception e)
            {
                // Console.WriteLine("Informe um valor válido");
            }
        } while (opc != 0);
        Console.WriteLine(" F I M ");
    }
    private static void Inserir_Time()
    {
        #region Conexao com o Banco
        Conexao_Banco conn = new Conexao_Banco();
        SqlConnection conexaosql = new SqlConnection(conn.Caminho());
        conexaosql.Open();
        #endregion

        #region Inserir_Time
        try
        {
            SqlCommand cmd = new SqlCommand("[dbo].[Inserir_Time]", conexaosql);
            cmd.CommandType = CommandType.StoredProcedure;
            //id_time
            //Console.WriteLine("Digite o nome do time que deseja incluir?");
            cmd.Parameters.Add(new SqlParameter("@nometime", SqlDbType.VarChar)).Value = "Nome do time";
            cmd.Parameters.Add(new SqlParameter("@data_criacao", SqlDbType.VarChar)).Value = "2024-01-01";
            cmd.Parameters.Add(new SqlParameter("@apelido", SqlDbType.VarChar)).Value = "APE";
            var returnValue = cmd.ExecuteNonQuery(); //Retorna a linha que foi executada

            Console.WriteLine("\n\nInserir_Time:\n" + returnValue.ToString());
            Console.WriteLine("Time inserido!");
            Console.ReadKey();
        }
        catch (Exception e)
        {
            //Caso queria controlar o erro
            Console.WriteLine("\nO time não pode ser inserido");
            Console.WriteLine(e.ToString());
            Console.ReadKey();
        }
        finally
        {
            conexaosql.Close();
        }
        #endregion
    }


    private static void Obter_Classificacao()
    {
        #region Conexao com o Banco
        Conexao_Banco conn = new Conexao_Banco();
        SqlConnection conexaosql = new SqlConnection(conn.Caminho());
        conexaosql.Open();
        #endregion

       /* #region Obter_Classificacao
        try
        {
            SqlCommand cmd = new SqlCommand("[dbo].[Obter_Classificacao]", conexaosql);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@pontuacao", SqlDbType.VarChar)).Value = "";
            var returnValue = cmd.ExecuteReader(); //Retorna a linha que foi executada
            if (!returnValue.HasRows)
            {
                Console.WriteLine("Times não localizados");
                Console.ReadKey();
                //throw new Exception("Não há registros"); //Poderia retornar uma Exception
            }
            else
            {
                Console.WriteLine("\n\n\"Times não localizados\"");
                while (returnValue.Read())
                {
                    int id = int.Parse(returnValue["id"].ToString());
                    string nome = returnValue["nome"].ToString();
                    string telefone = returnValue["telefone"].ToString();
                    string email = returnValue["email"].ToString();
                    //Poderia ter a classe e instanciar o contato aqui com os valores
                    Console.WriteLine("\nDados do Contato Localizado:");
                    Console.WriteLine($"ID: {id}, Nome: {nome}, Telefone: {telefone}, Email: {email}");
                    Console.WriteLine("-x-x-x-x-x-x-x-x-");
                    Console.ReadKey();
                }
                Console.WriteLine("Consulta Executada!");
                Console.ReadKey();
            }
        }
        catch (Exception e)
        {
            //Caso queria controlar o erro
            Console.WriteLine("\nMensagem da Exception que aconteceu:");
            Console.WriteLine(e.ToString());
            Console.ReadKey();
        }
        finally
        {
            conexaosql.Close();
        }
        #endregion*/
    }
}