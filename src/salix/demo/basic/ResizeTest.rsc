module salix::demo::basic::ResizeTest
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::SVG;
import salix::Slider;



alias Model = tuple[int width, int height];

Model startModel = <600, 600>;

data Msg
   = resizeX(int id, real x)
   | resizeY(int id, real y)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case resizeX(_, real x): m.width = round(x);
       case resizeY(_, real y): m.height = round(y);
       }
     return m;
}

Model init() = startModel;

Figure testVcat(Model m) = vcat(figs=[
                                       hcat(figs=[
                                           box(lineWidth=4, fillColor="yellow", lineColor="brown")
                                           // htmlText("Hello")
                                          ,box(lineWidth=4, fillColor="yellow", lineColor="brown", padding=<10, 10, 10, 10>
                                          )                                      
                                          ],borderStyle="groove", borderWidth = 2)
                                      ,box(lineWidth=4, fillColor="yellow", lineColor="red")
                                      ]);   
                                      
 Figure testLayout(Model m) {
      return 
      vcat(figs=[box(lineColor="black"), 
           hcat(figs = [shapes::Figure::circle(lineColor="blue"), shapes::Figure::ellipse(cx=40, cy = 90, lineColor="green")]),
           box(lineColor="red")]);
      }

         
 void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testLayout(m), width = m.width, height = m.height);
        slider([[
                  [<resizeX, 0, "width:", 0, 1600, 200, m.width> ]
                 ,[<resizeY, 0, "height:", 0, 1600, 200, m.height> ]
                 ]]);   
         });  
    }
    

    
 App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://mondriaan/src|);
   }
   
public App[Model] c = testApp();

public void main() {
     c.stop();
     c.serve();
     }