// Online Java Compiler
// Use this editor to write, compile and run your Java code online

class HelloWorld {
    public static void main(String[] args) {
        int rows = 6;  
        int cols = 31;
        
        int[][] points = {
            {1, 26}, 
            {2, 21}, {2, 26}, 
            {3, 5}, 
            {4, 5}, {4, 10},
        };
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if(i == 0 || i == rows-1 || j == 0 || j == cols-1){
                    System.out.print("*");
                }else if(isPoint(i,j,points)){
                    System.out.print("#");
                }
                else {
                    System.out.print(" ");
                }
            }
            System.out.println(); 
        }
    }
    private static boolean isPoint(int i,int j, int[][] positions){
        for (int[] position : positions) {
            if (position[0] == i && position[1] == j) {
                return true;
            }
        }
        return false;
    }
}
