module salix::demo::basic::Plot
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;

alias Model = tuple[num x, num y];

Model startModel = <0, 0>;

data Msg
   = moveX(num x)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case moveX(num x): 
     return m;
     }
}

Model init() = startModel;


Figure testFigure(Model m) {
     int n  = 100;
     return overlay(size=<400, 400>, figs=[box(size=<400, 400>, lineWidth=2, lineColor="black"), 
       path([p_.M(0, 0)]+[p_.L(i/n, sin(2*PI()*i/n))|num i<-[1,1+1.0/n..n]]
       ,scaleX=400, scaleY=400)
       ]);
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 600, height = 700);     
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