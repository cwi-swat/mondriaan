module salix::demo::basic::Colors
import util::Math;
import salix::HTML;
import salix::App;
// import salix::Core;
import salix::LayoutFigure;
import shapes::Figure;
import Prelude;

// alias Model = list[list[tuple[num width, num height]]];
alias Model = tuple[int width, int height];

// Model startModel = [[<30, 30>|__<-[0..4]]|_<-[0..5]];

Model startModel = <50, 50>;

data Msg
  = wdth(int w, int x = 10)
  | hght(int h)
  ;

// \<input type=\"range\" min=\"<f.low>\" max=\"<f.high>\" step=\"<f.step>\" id=\"<id>\"  class=\"form\" value= \"<f.\value>\"/\>

Model update(Msg msg, Model m) {
    switch (msg) {
       case wdth(int w): {println(msg.x);m.width=w;}
       case hght(int h): m.height=h;
       }
     return m;
     }

Model init() = startModel;

void slider(Msg(int) msg, int low, int high) {
    salix::HTML::input(
            salix::HTML::\type("range")
           ,salix::HTML::min("<low>")
           ,salix::HTML::max("<high>")
           ,salix::HTML::onChange(msg)
         );
    }
    
 Figure testFigure(Model m) {
   return box(width=m.width, height = m.height, fillColor= "antiqueWhite",
      lineWidth =2, lineColor="coral", fig = box(fillColor="navy", shrink=0.7,
      lineColor = "green", lineWidth = 2));
   }
   
void widthHeightSlider(int low, int high) { 
       list[tuple[str, str]] styles=[];     
       styles += <"border-spacing", "5px 5px">;
       styles+= <"border-collapse", "separate">;
       styles+= <"width", "300px">;
       // Msg(int) q1(){return (int v) {wdth(v);};}
       // q.x=1;
       table(salix::HTML::style(styles), (){
                tr((){
                 td("width:");
                 td("<low>");
                 td(() {slider(wdth, low, high);});
                 td("<high>");
                });
                tr((){
                 td("height:");
                 td("<low>");
                 td(() {slider(hght, low, high);});
                 td("<high>");
                });
           });
    }

void myView(Model m) { 
    int low = 30; int high = 100;
    div(() {
       h2("Figure using Slider");
       fig(testFigure(m));
           widthHeightSlider(low, high);
           });
       }
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------

App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://salix/src|);
   }
   
public App[Model] c = testApp();

public void main() {
     c.stop();
     c.serve();
     }