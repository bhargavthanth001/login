// Online Java Compiler
// Use this editor to write, compile and run your Java code online

class HelloWorld {
    public static void main(String[] args) {
        int rows = 6;  
        int cols = 6;
        
        int[][] points = {
            {1, 4}, 
            {2, 3}, {2, 4}, 
            {3, 1}, 
            {4, 1}, {4, 2},
        };
        
        for(int i = 0; i < rows; i++){
            for(int j = 0; j < cols; j++){
                 if(i == 0 || i == rows-1 || j == 0 || j == cols-1){
                    System.out.print("*");
                }else{
                    if(isPoint(i,j,points)){
                      System.out.print("0");    
                    }else{
                        System.out.print(" ");
                    }
                }
                if(j != cols-1){
                    System.out.print("    ");
                }
            }
            System.out.println();
        }
    }
    
    private static boolean isPoint(int i, int j, int[][] positions){
        for (int[] position : positions) {
            if (position[0] == i && position[1] == j) {
                return true;
            }
        }
        return false;
    }
}
