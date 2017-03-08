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
     int n  = 50;
     return box(lineWidth=2, lineColor="black", fig=overlay(size=<700, 200>, figs=[
       path([p_.M(0, 0)]+[p_.L(2*PI()*i/n, sin(2*PI()*i/n))|num i<-[1,1+1.0/n..2*n]]
       ,scaleX=100, scaleY=-100, at=<0, 100>, fillColor="none", lineColor="red")
       , path([p_.M(0, 1)]+[p_.L(2*PI()*i/n, cos(2*PI()*i/n))|num i<-[1,1+1.0/n..2*n]]
       ,scaleX=100, scaleY=-100, at=<0, 100>, fillColor="none", lineColor="blue")
       ]));
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 800, height = 700);     
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