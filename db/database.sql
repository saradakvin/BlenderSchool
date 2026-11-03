PRAGMA foreign_keys = ON;
-- =====================================================
-- BlenderSchool – SQL database (SQLite, runs in the browser)
-- js/db.js runs this file on the first visit. MySQL version: php/database.sql
-- =====================================================



DROP TABLE IF EXISTS komentar;
DROP TABLE IF EXISTS objava;
DROP TABLE IF EXISTS napredek;
DROP TABLE IF EXISTS lekcija;
DROP TABLE IF EXISTS modul;
DROP TABLE IF EXISTS bliznjica;
DROP TABLE IF EXISTS uporabnik;

-- Users (the password is stored only as a hash, never as plain text)
CREATE TABLE uporabnik (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uporabnisko_ime VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    geslo_hash VARCHAR(255) NOT NULL,
    datum_registracije DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Modules (groups of lessons)
CREATE TABLE modul (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    naslov VARCHAR(100) NOT NULL,
    opis TEXT,
    vrstni_red INT NOT NULL DEFAULT 0
);

-- Lessons inside a module
CREATE TABLE lekcija (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_modula INT NOT NULL,
    naslov VARCHAR(150) NOT NULL,
    vsebina TEXT NOT NULL,
    slika_gif VARCHAR(255) NULL,
    vrstni_red INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_modula) REFERENCES modul(id) ON DELETE CASCADE
);

-- Progress: one row = one completed lesson
CREATE TABLE napredek (
    id_uporabnika INT NOT NULL,
    id_lekcije INT NOT NULL,
    datum_dokoncanja DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_uporabnika, id_lekcije),
    FOREIGN KEY (id_uporabnika) REFERENCES uporabnik(id) ON DELETE CASCADE,
    FOREIGN KEY (id_lekcije) REFERENCES lekcija(id) ON DELETE CASCADE
);

-- Shortcuts for the cheat sheet
CREATE TABLE bliznjica (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tipka VARCHAR(50) NOT NULL,
    opis VARCHAR(255) NOT NULL,
    kategorija VARCHAR(50) NOT NULL
);

-- Gallery posts (images of finished work)
CREATE TABLE objava (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_uporabnika INT NOT NULL,
    id_modula INT NOT NULL,
    pot_do_slike VARCHAR(255) NOT NULL,
    besedilo TEXT,
    datum DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_uporabnika) REFERENCES uporabnik(id) ON DELETE CASCADE,
    FOREIGN KEY (id_modula) REFERENCES modul(id) ON DELETE CASCADE
);

-- Comments on posts
CREATE TABLE komentar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_objave INT NOT NULL,
    id_uporabnika INT NOT NULL,
    besedilo TEXT NOT NULL,
    datum DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_objave) REFERENCES objava(id) ON DELETE CASCADE,
    FOREIGN KEY (id_uporabnika) REFERENCES uporabnik(id) ON DELETE CASCADE
);


-- =====================================================
-- SAMPLE DATA
-- =====================================================

INSERT INTO modul (id, naslov, opis, vrstni_red) VALUES
(1, 'Interface Basics', 'Find your way around Blender: editors, navigation, selecting and moving objects.', 1),
(2, 'Modeling', 'Build 3D shapes in Edit Mode with extrude, inset, loop cuts, bevels and modifiers.', 2),
(3, 'Texturing', 'Unwrap UVs, paint your own textures and use image textures from photos.', 3),
(4, 'Shading & Rendering', 'Materials, lights, the camera and your first finished render.', 4),
(5, 'Sculpting', 'Shape organic forms with sculpt brushes, like working with digital clay.', 5),
(6, 'Guided Projects', 'Three beginner models built click by click: a coffee mug, a cute cottage and a snowman.', 6),
(7, 'Course: Low-Poly Character', 'One long course (about 6 hours, 6 chapters, 22 steps): build a low-poly girl character from scratch, every click explained.', 7);

INSERT INTO lekcija (id_modula, naslov, vsebina, slika_gif, vrstni_red) VALUES
(1, 'The Blender Interface', '<p>When you open Blender and click away the splash screen you see the <b>default scene</b>: a cube, a camera and a light. Blender looks crowded at first, but the screen is just a few <b>editors</b> placed side by side.</p>
<h3>The four editors you use all the time</h3>
<table class="tabela">
<tr><th>Editor</th><th>Where</th><th>What it is for</th></tr>
<tr><td><b>3D Viewport</b></td><td>big area in the middle</td><td>See and edit your scene. Almost all modeling happens here.</td></tr>
<tr><td><b>Outliner</b></td><td>top right</td><td>A list of every object. Click a name to select it, click the eye icon to hide it, double-click to rename.</td></tr>
<tr><td><b>Properties</b></td><td>bottom right</td><td>Settings for the selected object. The vertical tabs on its left side switch between Render, Output, World, Object, <b>Modifiers</b> (wrench), <b>Material</b> (red sphere) and more.</td></tr>
<tr><td><b>Timeline</b></td><td>bottom</td><td>Frames and keyframes for animation. You can ignore it while modeling.</td></tr>
</table>
<h3>Workspaces</h3>
<p>The tabs at the very top (<b>Layout, Modeling, Sculpting, UV Editing, Texture Paint, Shading, ...</b>) are <b>workspaces</b>. Each one is the same scene with editors arranged for one job. Switching tabs never changes your model, only the layout around it.</p>
<h3>Changing the layout</h3>
<ul>
<li>Drag the border between two editors to resize them.</li>
<li>Every editor has an <b>Editor Type</b> button in its top-left corner. Click it to turn that area into any other editor.</li>
<li><kbd>Ctrl</kbd>+<kbd>Space</kbd> with the mouse over an editor maximizes it. Press it again to go back.</li>
</ul>
<h3>Panels inside the 3D Viewport</h3>
<ul>
<li><kbd>T</kbd> toggles the <b>Toolbar</b> on the left (select, move, rotate, scale, ... tools).</li>
<li><kbd>N</kbd> toggles the <b>Sidebar</b> on the right. Its <b>Item</b> tab shows exact Location, Rotation, Scale and Dimensions, and you can type numbers there.</li>
<li>After almost every action a small <b>Adjust Last Operation</b> panel appears in the bottom-left corner. Open it to change the settings of what you just did, for example the number of vertices of a new cylinder. If you click somewhere else it disappears, so use it right away.</li>
</ul>
<h3>Three keys that save beginners</h3>
<ul>
<li><kbd>F3</kbd> opens <b>search</b>. Type the name of any command (for example "bevel") and press Enter.</li>
<li><kbd>Ctrl</kbd>+<kbd>Z</kbd> undoes, <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Z</kbd> redoes.</li>
<li><kbd>Ctrl</kbd>+<kbd>S</kbd> saves your .blend file. Blender also keeps automatic backups (File &rarr; Recover).</li>
</ul>
<div class="nasvet">Keyboard shortcuts work on the editor your <b>mouse is over</b>. If a shortcut "does nothing", move the mouse over the 3D Viewport and try again.</div>
<h3>Try it</h3>
<ol><li>Click the camera in the Outliner and look at how the Properties tabs change.</li><li>Switch to the <b>Shading</b> workspace and back to <b>Layout</b>.</li><li>Press <kbd>N</kbd>, select the cube and change its Location Z to 2 in the Item tab.</li></ol>', 'img/lekcije/zacetna_scena.jpg', 1),

(1, 'Navigating the 3D Viewport', '<p>Before you can build anything you need to look at it from every side. Navigation never changes your scene; it only moves your <b>view</b>.</p>
<table class="tabela">
<tr><th>Action</th><th>Mouse / keyboard</th></tr>
<tr><td>Orbit (rotate the view)</td><td>hold <kbd>Middle mouse</kbd> and drag</td></tr>
<tr><td>Pan (slide the view)</td><td><kbd>Shift</kbd> + <kbd>Middle mouse</kbd> drag</td></tr>
<tr><td>Zoom</td><td>scroll the wheel, or <kbd>Ctrl</kbd> + <kbd>Middle mouse</kbd> drag</td></tr>
<tr><td>Front / Right / Top view</td><td><kbd>Numpad 1</kbd> / <kbd>Numpad 3</kbd> / <kbd>Numpad 7</kbd></td></tr>
<tr><td>Back / Left / Bottom view</td><td><kbd>Ctrl</kbd> + the same numpad key</td></tr>
<tr><td>Perspective / Orthographic</td><td><kbd>Numpad 5</kbd></td></tr>
<tr><td>Zoom to the selected object</td><td><kbd>Numpad .</kbd> (View &rarr; Frame Selected)</td></tr>
<tr><td>Show everything</td><td><kbd>Home</kbd></td></tr>
<tr><td>Look through the camera</td><td><kbd>Numpad 0</kbd></td></tr>
</table>
<h3>No numpad or no mouse wheel?</h3>
<ul>
<li>Press <kbd>~</kbd> (the key left of 1) for a pie menu with all views.</li>
<li>Use the <b>navigation gizmo</b> in the top-right corner of the viewport: click X, Y or Z to snap to that view, drag the ball to orbit, drag the hand icon to pan and the magnifier to zoom.</li>
<li>On a laptop go to <b>Edit &rarr; Preferences &rarr; Input</b> and turn on <b>Emulate 3 Button Mouse</b> (then <kbd>Alt</kbd> + left drag orbits) and <b>Emulate Numpad</b> (then the normal 1, 3, 7 keys switch views).</li>
</ul>
<h3>Viewport shading</h3>
<p>Press <kbd>Z</kbd> for the shading pie menu, or use the four sphere buttons in the top-right corner:</p>
<ul>
<li><b>Wireframe</b> shows only edges. Good for seeing through objects.</li>
<li><b>Solid</b> is the default gray clay look. Fast and best for modeling.</li>
<li><b>Material Preview</b> shows your materials and textures with a test light.</li>
<li><b>Rendered</b> shows what the final render will look like with your own lights.</li>
</ul>
<div class="nasvet">Orthographic front/side views (<kbd>Numpad 1</kbd> then <kbd>Numpad 3</kbd>) are perfect for lining things up, because nothing gets smaller with distance.</div>
<h3>Try it</h3>
<p>Orbit around the cube, then press <kbd>Numpad 1</kbd>, <kbd>Numpad 3</kbd> and <kbd>Numpad 7</kbd>. Notice the label in the top-left corner of the viewport changes to "Front Orthographic", "Right Orthographic" and "Top Orthographic".</p>', 'img/lekcije/gif_premikanje.gif', 2),

(1, 'Selecting, Adding and Transforming Objects', '<h3>Selecting</h3>
<ul>
<li><b>Left click</b> selects one object. The lighter orange outline is the <b>active</b> object.</li>
<li><kbd>Shift</kbd> + click adds to the selection (or removes an already selected object).</li>
<li><kbd>A</kbd> selects all, <kbd>Alt</kbd>+<kbd>A</kbd> deselects all, <kbd>Ctrl</kbd>+<kbd>I</kbd> inverts.</li>
<li><kbd>B</kbd> box select (drag a rectangle), <kbd>C</kbd> circle select (paint over objects, right click to finish).</li>
</ul>
<h3>Adding, duplicating and deleting</h3>
<ul>
<li><kbd>Shift</kbd>+<kbd>A</kbd> opens the Add menu (Mesh &rarr; Cube, UV Sphere, Cylinder, ...). New objects appear at the <b>3D cursor</b> (the red-white circle).</li>
<li><kbd>Shift</kbd> + <b>right click</b> moves the 3D cursor. <kbd>Shift</kbd>+<kbd>S</kbd> &rarr; <b>Cursor to World Origin</b> puts it back in the center.</li>
<li><kbd>Shift</kbd>+<kbd>D</kbd> duplicates and starts moving the copy. Right click to leave the copy in the same place.</li>
<li><kbd>X</kbd> or <kbd>Delete</kbd> deletes the selection.</li>
</ul>
<h3>Move, rotate, scale</h3>
<p>Press a key, move the mouse, then <b>left click</b> (or <kbd>Enter</kbd>) to confirm. <b>Right click</b> (or <kbd>Esc</kbd>) cancels.</p>
<table class="tabela">
<tr><th>Key</th><th>Does</th><th>Example</th></tr>
<tr><td><kbd>G</kbd></td><td>Move (grab)</td><td><kbd>G</kbd> <kbd>Z</kbd> <kbd>2</kbd> <kbd>Enter</kbd> moves 2 m up</td></tr>
<tr><td><kbd>R</kbd></td><td>Rotate</td><td><kbd>R</kbd> <kbd>X</kbd> <kbd>9</kbd><kbd>0</kbd> <kbd>Enter</kbd> rotates 90&deg; around X</td></tr>
<tr><td><kbd>S</kbd></td><td>Scale</td><td><kbd>S</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>5</kbd> <kbd>Enter</kbd> makes it half the size</td></tr>
</table>
<ul>
<li>After G, R or S press <kbd>X</kbd>, <kbd>Y</kbd> or <kbd>Z</kbd> to lock to that axis. Press <kbd>Shift</kbd>+<kbd>Z</kbd> to lock to everything <i>except</i> Z (for example, scale only width and depth).</li>
<li>Hold <kbd>Ctrl</kbd> while moving to snap in steps, hold <kbd>Shift</kbd> for slow, precise movement.</li>
<li><kbd>Alt</kbd>+<kbd>G</kbd>, <kbd>Alt</kbd>+<kbd>R</kbd>, <kbd>Alt</kbd>+<kbd>S</kbd> reset location, rotation or scale.</li>
</ul>
<h3>Apply the scale (important!)</h3>
<p>If you scale an object in Object Mode, Blender remembers the scale (for example 3, 1, 1). Tools such as Bevel, Inset and many modifiers then look stretched. Fix it with <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>. The object looks the same, but its scale is reset to 1.</p>
<div class="nasvet">Typing numbers is the secret to clean models. Instead of guessing with the mouse, type the exact value after G, R or S.</div>
<h3>Try it</h3>
<ol><li>Add a UV Sphere and move it up with <kbd>G</kbd> <kbd>Z</kbd> <kbd>2</kbd>.</li><li>Duplicate it with <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>X</kbd> <kbd>3</kbd> <kbd>Enter</kbd>.</li><li>Make the copy flat: <kbd>S</kbd> <kbd>Z</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>3</kbd>, then apply the scale with <kbd>Ctrl</kbd>+<kbd>A</kbd>.</li></ol>', 'img/lekcije/gif_transformacije.gif', 3),

(2, 'Edit Mode: Vertices, Edges and Faces', '<p>A mesh is made of <b>vertices</b> (points), <b>edges</b> (lines between points) and <b>faces</b> (surfaces between edges). In Object Mode you move whole objects; in <b>Edit Mode</b> you change their shape.</p>
<ul>
<li><kbd>Tab</kbd> switches between Object Mode and Edit Mode for the selected object.</li>
<li><kbd>1</kbd> vertex select, <kbd>2</kbd> edge select, <kbd>3</kbd> face select (top row keys, not numpad). The same buttons are in the viewport header.</li>
<li><kbd>G</kbd>, <kbd>R</kbd>, <kbd>S</kbd>, axis locking and typed numbers work exactly like in Object Mode.</li>
</ul>
<h3>Smart selection</h3>
<table class="tabela">
<tr><th>Shortcut</th><th>Selects</th></tr>
<tr><td><kbd>Alt</kbd> + click an edge</td><td>the whole <b>edge loop</b> (a ring of edges around the model)</td></tr>
<tr><td><kbd>Ctrl</kbd> + click</td><td>the shortest path between the last selected element and the click</td></tr>
<tr><td><kbd>L</kbd> with the mouse over a part</td><td>everything connected to it</td></tr>
<tr><td><kbd>Ctrl</kbd> + <kbd>Numpad +</kbd> / <kbd>-</kbd></td><td>grow / shrink the selection</td></tr>
<tr><td><kbd>Alt</kbd>+<kbd>Z</kbd></td><td>X-ray, so box select also grabs the hidden back side</td></tr>
</table>
<h3>Deleting the right way</h3>
<p><kbd>X</kbd> opens a menu. <b>Vertices / Edges / Faces</b> remove geometry and leave a hole. <b>Dissolve</b> removes edges or vertices but keeps the surface closed. Use dissolve when you want to clean up, delete when you want a hole.</p>
<h3>Joining and filling</h3>
<ul>
<li><kbd>M</kbd> merges selected vertices (At Center, At Last, <b>By Distance</b> to remove doubled vertices).</li>
<li><kbd>F</kbd> fills: two vertices become an edge, a closed ring of edges becomes a face.</li>
</ul>
<h3>Proportional editing</h3>
<p>Press <kbd>O</kbd> to toggle it. Now moving one vertex also pulls its neighbors softly. Scroll the mouse wheel while moving to change the circle of influence. Great for hills, cloth and bumps.</p>
<div class="nasvet">The statistics overlay shows how many vertices and faces are selected. Turn it on in the <b>Overlays</b> dropdown &rarr; Statistics.</div>
<h3>Try it</h3>
<p>On the default cube: <kbd>Tab</kbd>, <kbd>3</kbd>, click the top face, <kbd>G</kbd> <kbd>Z</kbd> <kbd>1</kbd> <kbd>Enter</kbd>. The cube becomes a tall box. Now press <kbd>2</kbd>, <kbd>Alt</kbd>+click a vertical edge and scale it with <kbd>S</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>5</kbd>.</p>', 'img/lekcije/edit_mode.jpg', 1),

(2, 'Extrude, Inset, Loop Cut and Bevel', '<p>These four tools build almost every beginner model. All of them work in <b>Edit Mode</b>.</p>
<h3>Extrude <kbd>E</kbd></h3>
<p>Pulls new geometry out of the selection. Select a face, press <kbd>E</kbd> and move the mouse; the new face moves along its normal (straight out). Type a number to set the distance: <kbd>E</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>5</kbd> <kbd>Enter</kbd>. A negative number pushes inward (<kbd>E</kbd> <kbd>-</kbd><kbd>0</kbd><kbd>.</kbd><kbd>2</kbd>), which is how you make a dent. With several faces selected, <kbd>Alt</kbd>+<kbd>E</kbd> &rarr; <b>Extrude Faces Along Normals</b> pushes each one straight out.</p>
<div class="nasvet">If you press E and then cancel with a right click, the new geometry still exists, sitting on top of the old one. Press <kbd>Ctrl</kbd>+<kbd>Z</kbd> to really undo it.</div>
<h3>Inset <kbd>I</kbd></h3>
<p>Makes a smaller copy of a face inside it, with a border around it. Move the mouse toward the face center or type a thickness (<kbd>I</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>1</kbd>). Press <kbd>I</kbd> twice to inset each selected face separately. Inset + extrude inward = windows, doors, screens and holes.</p>
<h3>Loop Cut <kbd>Ctrl</kbd>+<kbd>R</kbd></h3>
<ol>
<li>Hover over an edge. A yellow preview line appears across it.</li>
<li><b>Scroll</b> the wheel to add more cuts.</li>
<li><b>Left click</b> to place the cut. Now you can slide it.</li>
<li><b>Right click</b> to keep it exactly in the middle, or left click to confirm the slid position.</li>
</ol>
<p>Loop cuts add rows of faces where you need detail, and they keep edges sharp when you use subdivision (next lesson).</p>
<h3>Bevel <kbd>Ctrl</kbd>+<kbd>B</kbd></h3>
<p>Rounds or cuts off selected edges. Move the mouse for the width and <b>scroll</b> for more segments (2 or 3 segments look round). Real objects never have perfectly sharp edges, so a small bevel makes models look much more real. <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>B</kbd> bevels vertices instead.</p>
<h3>Bonus tools</h3>
<ul>
<li><kbd>K</kbd> <b>Knife</b>: click to draw new edges across faces, <kbd>Enter</kbd> to confirm.</li>
<li><b>Bridge Edge Loops</b> (Edge menu): connects two selected edge loops with faces, for example to join two tubes.</li>
</ul>
<h3>Try it: a picture frame</h3>
<ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; Plane, then <kbd>Tab</kbd> and <kbd>3</kbd>.</li><li><kbd>I</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>2</kbd> <kbd>Enter</kbd>. The inner face will be the picture.</li><li><kbd>Ctrl</kbd>+<kbd>I</kbd> inverts the selection so the frame border is selected. <kbd>E</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>1</kbd> <kbd>Enter</kbd> raises the frame.</li><li>Press <kbd>2</kbd>, <kbd>Alt</kbd>+click the outer top edge of the frame, <kbd>Ctrl</kbd>+<kbd>B</kbd>, scroll to 2 segments and click to round it.</li></ol>', 'img/lekcije/gif_extrude.gif', 2),

(2, 'Modifiers: Subdivision, Mirror, Bevel, Solidify, Array', '<p>A <b>modifier</b> changes how an object looks without destroying its original mesh. You can change or remove it at any time. Find them in the <b>Properties &rarr; Modifiers</b> tab (blue wrench) &rarr; <b>Add Modifier</b>.</p>
<h3>Subdivision Surface</h3>
<p>Splits every face into smaller faces and smooths the result, so a blocky cage becomes a smooth model. Shortcut in Object Mode: <kbd>Ctrl</kbd>+<kbd>1</kbd>, <kbd>2</kbd> or <kbd>3</kbd> (the level). Also right click &rarr; <b>Shade Smooth</b> so the faces look smooth instead of faceted.</p>
<p><b>Problem:</b> a subdivided cube turns into a ball. <b>Fix:</b> add <b>support loops</b> with <kbd>Ctrl</kbd>+<kbd>R</kbd> close to the edges that should stay sharp. The closer the loops, the sharper the edge.</p>
<h3>Mirror</h3>
<p>Model one half, get the other half for free. In Edit Mode delete one half of the model (for example everything with negative X), add a <b>Mirror</b> modifier and turn on <b>Clipping</b> so vertices in the middle cannot cross the center. Perfect for faces, characters, cars and furniture.</p>
<h3>Bevel</h3>
<p>Bevels every edge automatically. Set <b>Amount</b> (width) and <b>Segments</b>. Under <b>Limit Method &rarr; Angle</b> only sharp edges are beveled. Apply the object scale first (<kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale), otherwise the bevel is uneven.</p>
<h3>Solidify</h3>
<p>Gives a flat surface thickness. Make a plane, add Solidify, and you have a wall, a sheet of paper or a leaf with a real thickness.</p>
<h3>Array</h3>
<p>Repeats the object. <b>Count</b> sets how many copies, <b>Relative Offset</b> sets the gap (1 = touching). Great for fences, stairs and chains.</p>
<h3>The stack order matters</h3>
<p>Modifiers run from top to bottom. Mirror above Subdivision gives a smooth seam in the middle; the opposite order can leave a crease. Drag the handle (six dots) on a modifier to reorder. When you are happy, use the dropdown arrow &rarr; <b>Apply</b> (or <kbd>Ctrl</kbd>+<kbd>A</kbd> with the mouse over the modifier) to make it real geometry.</p>
<div class="nasvet">Keep modifiers live as long as possible. Applying is permanent, and you lose the ability to change the settings.</div>
<h3>Try it</h3>
<p>Add a cube, press <kbd>Ctrl</kbd>+<kbd>2</kbd> and Shade Smooth. Then in Edit Mode add a loop cut near the top edge and watch the top become flatter as you slide the loop closer to the edge.</p>', 'img/lekcije/gif_subdivision.gif', 3),

(3, 'UV Unwrapping', '<p>A texture is a flat 2D image. To wrap it around a 3D model, Blender needs a <b>UV map</b>: the model cut open and laid flat, like a cardboard box that you cut and unfold. U and V are just the names of the two axes of the image.</p>
<h3>Step 1: mark seams</h3>
<p>Seams are the edges where the model will be cut. For a cylinder (like a mug or a can) that is the ring around the top, the ring around the bottom and one vertical edge.</p>
<ol>
<li>Go to the <b>UV Editing</b> workspace. Left is the UV Editor, right is the 3D Viewport in Edit Mode.</li>
<li>Press <kbd>2</kbd> for edge select. <kbd>Alt</kbd>+click the top ring, <kbd>Shift</kbd>+<kbd>Alt</kbd>+click the bottom ring, <kbd>Shift</kbd>+click one vertical edge.</li>
<li>Press <kbd>Ctrl</kbd>+<kbd>E</kbd> (Edge menu) &rarr; <b>Mark Seam</b>. The edges turn red.</li>
</ol>
<h3>Step 2: unwrap</h3>
<p>Select everything with <kbd>A</kbd>, press <kbd>U</kbd> &rarr; <b>Unwrap</b>. The UV Editor now shows flat pieces called <b>islands</b>: two circles (top and bottom) and a long rectangle (the side).</p>
<h3>Other unwrap options in the <kbd>U</kbd> menu</h3>
<ul>
<li><b>Smart UV Project</b>: cuts automatically by angle. Fast and good for hard-surface objects like boxes, furniture and buildings. No seams needed.</li>
<li><b>Cube / Cylinder / Sphere Projection</b>: project from a simple shape.</li>
<li><b>Project From View</b>: projects exactly what you see from the current view, useful for flat things like a poster.</li>
</ul>
<h3>Step 3: check for stretching</h3>
<ol>
<li>In the UV Editor open the <b>Overlays</b> dropdown and enable <b>Display Stretch</b>. Blue means fine, green to red means more and more stretched.</li>
<li>For a visual test, in the UV Editor click <b>Image &rarr; New</b>, set <b>Generated Type</b> to <b>UV Grid</b> and connect that image to your material''s Base Color (see "Image Textures"). Squares should look square on the model.</li>
<li>If squares on the grid look stretched, add or move seams and unwrap again.</li>
</ol>
<h3>Arrange the islands</h3>
<p>In the UV Editor you can move, rotate and scale islands with <kbd>G</kbd>, <kbd>R</kbd>, <kbd>S</kbd>. <b>UV &rarr; Average Islands Scale</b> makes all islands the same texel density, and <b>UV &rarr; Pack Islands</b> fits them neatly into the square without overlapping.</p>
<div class="nasvet">Hide seams where nobody looks: under the object, behind it, or along natural edges like where a sleeve meets a shirt.</div>
<h3>Try it</h3>
<p>Add a cylinder, mark the three seams described above, unwrap and use Pack Islands. You will reuse this exact UV map when you paint the mug in the next lesson.</p>', 'img/lekcije/teksturiranje.jpg', 1),

(3, 'Texture Painting: How to Actually Paint', '<p>In Texture Paint mode you paint colors straight onto the 3D model, like painting a real figure with a brush. The paint is stored in an <b>image</b> that is wrapped around the model with the UV map from the previous lesson.</p>
<h3>1. Prepare the model</h3>
<ol>
<li>Make sure the model has a UV map (Edit Mode, <kbd>A</kbd>, <kbd>U</kbd> &rarr; Unwrap or Smart UV Project). Overlapping UV islands would paint in two places at once.</li>
<li>Give the object a material: Properties &rarr; <b>Material</b> tab &rarr; <b>New</b>.</li>
<li>Apply the scale (<kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale), otherwise the brush looks squished.</li>
</ol>
<h3>2. Create an image to paint on</h3>
<ol>
<li>Switch to the <b>Texture Paint</b> workspace. If the model is <b>pink/purple</b>, it means "no texture to paint on yet". That is normal.</li>
<li>In the Properties editor open the <b>Active Tool</b> tab (screwdriver and wrench icon) and find the <b>Texture Slots</b> panel. Keep <b>Mode: Material</b>.</li>
<li>Click <b>+</b> and choose <b>Base Color</b>. Name it (for example <code>mug_color</code>), set <b>Width</b> and <b>Height</b> to <b>2048</b>, pick a starting <b>Color</b> (white or the main color of your object) and click <b>OK</b>.</li>
<li>Blender creates the image and connects it to the Base Color of your material automatically. The model now shows the starting color.</li>
</ol>
<h3>3. Know your brush settings</h3>
<p>All important settings are in the viewport header at the top (and in the Active Tool tab):</p>
<table class="tabela">
<tr><th>Setting</th><th>How</th><th>What it does</th></tr>
<tr><td><b>Color</b></td><td>click the color swatch</td><td>The color you paint with. Use the wheel or type a Hex code like <code>FF8A1F</code>.</td></tr>
<tr><td><b>Radius</b></td><td><kbd>F</kbd>, move mouse, click</td><td>Brush size in pixels on screen. Zooming in makes the brush relatively smaller for fine details.</td></tr>
<tr><td><b>Strength</b></td><td><kbd>Shift</kbd>+<kbd>F</kbd></td><td>How much paint each stroke puts down. 1.0 is full color, 0.2 is a light glaze you can build up.</td></tr>
<tr><td><b>Blend</b></td><td>dropdown</td><td><b>Mix</b> paints normally, <b>Multiply</b> darkens (shadows, dirt), <b>Add/Lighten</b> brightens, <b>Erase Alpha</b> erases to transparent.</td></tr>
<tr><td><b>Falloff</b></td><td>Falloff panel</td><td>Soft edge or hard edge. Choose the <b>Constant</b> preset for crisp shapes, <b>Smooth</b> for soft gradients.</td></tr>
<tr><td><b>Sample color</b></td><td><kbd>S</kbd> over the model</td><td>Picks a color from the model, like an eyedropper.</td></tr>
<tr><td><b>Swap colors</b></td><td><kbd>X</kbd></td><td>Swaps the primary and secondary color, handy for going back and forth between two colors.</td></tr>
</table>
<h3>4. The paint tools (brushes)</h3>
<p>In Blender 4.3 and newer, brushes are chosen from the <b>brush picker</b> in the header (asset shelf). In older versions they are tools in the left toolbar. The names are the same:</p>
<ul>
<li><b>Paint / Draw</b>: the normal brush. Use it for almost everything.</li>
<li><b>Soften</b>: blurs what you painted, to blend two colors.</li>
<li><b>Smear</b>: drags colors like wet paint.</li>
<li><b>Clone</b>: copies one part of the image to another (<kbd>Ctrl</kbd>+click sets the source).</li>
<li><b>Fill</b>: fills an area with one color in a single click. Turn the <b>Fill Threshold</b> up to fill bigger areas. In <b>Gradient</b> mode you drag to make a gradient.</li>
<li><b>Mask</b>: paints a protective mask so other brushes cannot paint there.</li>
</ul>
<h3>5. Paint with control</h3>
<ul>
<li><b>Stroke Method</b> (Stroke panel): <b>Space</b> is the normal smooth stroke, <b>Line</b> lets you drag a perfectly straight line, <b>Airbrush</b> keeps adding paint while you hold still.</li>
<li><b>Symmetry</b>: the butterfly icon in the header with <b>X</b> enabled paints both sides at once, perfect for faces.</li>
<li><b>Paint Mask (face selection)</b>: in Edit Mode select only the faces you want, go back to Texture Paint and enable the <b>Paint Mask</b> button (cube with a face) in the header. Now paint goes <i>only</i> on those faces. This is the easiest way to paint clean stripes or a label.</li>
<li><b>Bleed</b> (Options panel): how many pixels the paint spills past UV island borders. Raise it to 8&ndash;16 px if you see thin seams in the paint.</li>
<li>With a <b>graphics tablet</b>, click the pressure icons next to Radius and Strength so pressing harder paints bigger or stronger.</li>
</ul>
<h3>6. A good painting workflow</h3>
<ol>
<li>Start with a <b>base color</b> (the color you chose in step 2).</li>
<li>Block in big color areas with a hard brush (Constant falloff, strength 1).</li>
<li>Add soft shading: <b>Multiply</b> blend, dark color, strength 0.1&ndash;0.2, soft falloff, in corners and under parts.</li>
<li>Add highlights: <b>Lighten</b> blend on edges that stick out.</li>
<li>Add small details last (zoom in, small radius).</li>
</ol>
<h3>7. SAVE THE IMAGE</h3>
<p>The painted image is <b>not</b> saved when you press <kbd>Ctrl</kbd>+<kbd>S</kbd> for the .blend file! In the Image Editor on the left use <b>Image &rarr; Save As</b> (<kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd>) and save a PNG next to your .blend file. After that, <b>Image &rarr; Save</b> (<kbd>Alt</kbd>+<kbd>S</kbd>) updates it. An asterisk (<b>*</b>) next to the Image menu means there are unsaved changes. Alternative: <b>File &rarr; External Data &rarr; Pack Resources</b> stores the image inside the .blend file.</p>
<div class="nasvet">You can also paint in 2D: in the Image Editor switch the mode in the header from View to <b>Paint</b>. Painting on the flat UV layout is great for straight lines and text.</div>
<h3>Try it: paint the mug</h3>
<ol><li>Unwrap your mug (or a cylinder), add a 2048 Base Color texture in light blue.</li><li>Select the middle ring of faces in Edit Mode, enable Paint Mask and paint a white stripe with a hard brush.</li><li>Turn Paint Mask off, use Multiply with a dark blue at strength 0.15 to shade the bottom.</li><li>Save the image with <b>Image &rarr; Save As</b>.</li></ol>', 'img/lekcije/barvanje.jpg', 2),

(3, 'Image Textures from Photos', '<p>Instead of painting everything yourself, you can use photo textures like wood, bricks or fabric. Free, safe sources are <b>Poly Haven</b> and <b>ambientCG</b> (both CC0, free to use for anything).</p>
<h3>What is in a texture set?</h3>
<table class="tabela">
<tr><th>Map</th><th>Connect to</th><th>Color Space</th></tr>
<tr><td>Color / Albedo / Diffuse</td><td>Base Color</td><td>sRGB</td></tr>
<tr><td>Roughness</td><td>Roughness</td><td><b>Non-Color</b></td></tr>
<tr><td>Normal (often "_nor_gl")</td><td>Normal Map node &rarr; Normal</td><td><b>Non-Color</b></td></tr>
<tr><td>Displacement / Height</td><td>Displacement node (optional)</td><td><b>Non-Color</b></td></tr>
</table>
<h3>Connect a texture by hand</h3>
<ol>
<li>Open the <b>Shading</b> workspace. The bottom half is the <b>Shader Editor</b> with your material''s nodes.</li>
<li>Drag the image file from your computer into the Shader Editor, or press <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Texture &rarr; <b>Image Texture</b> and click <b>Open</b>.</li>
<li>Drag from the yellow <b>Color</b> output dot to the <b>Base Color</b> input of the Principled BSDF.</li>
<li>For roughness and normal maps change <b>Color Space</b> on the image node to <b>Non-Color</b>, otherwise the material looks wrong.</li>
</ol>
<h3>The fast way: Node Wrangler</h3>
<p>Enable it once: <b>Edit &rarr; Preferences &rarr; Add-ons</b>, search "Node Wrangler", tick the box. Then:</p>
<ul>
<li>Select the Principled BSDF and press <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>T</kbd>. Select all maps of a texture set at once and click <b>Principled Texture Setup</b>. Every map is connected correctly with the right color space.</li>
<li>Select an image node and press <kbd>Ctrl</kbd>+<kbd>T</kbd> to add <b>Texture Coordinate</b> and <b>Mapping</b> nodes.</li>
</ul>
<h3>Make the texture the right size</h3>
<p>In the <b>Mapping</b> node increase <b>Scale</b> (for example 4, 4, 4) to make the pattern repeat more often, so bricks are not giant. Rotation Z turns the pattern. If the texture looks stretched, the UVs are stretched: go back to the UV Unwrapping lesson.</p>
<div class="nasvet">Seamless (tileable) textures repeat without visible edges. Most textures from Poly Haven and ambientCG are seamless.</div>
<h3>Try it</h3>
<p>Download a wood texture, unwrap a cube with Smart UV Project and use Node Wrangler to set it up. Change the Mapping scale until the wood grain looks realistic.</p>', 'img/lekcije/teksturiranje.jpg', 3),

(4, 'Materials and the Principled BSDF', '<p>A material decides how light reacts with a surface: color, shine, metal, glass or glow. Blender''s main shader is the <b>Principled BSDF</b>, which can make almost every real material.</p>
<h3>Create a material</h3>
<ol>
<li>Select an object, open the <b>Material</b> tab (red sphere) in Properties and click <b>New</b>.</li>
<li>Double-click the name and give it a real name (for example <code>Ceramic Blue</code>).</li>
<li>Press <kbd>Z</kbd> &rarr; <b>Material Preview</b> to see it.</li>
</ol>
<h3>The settings that matter</h3>
<table class="tabela">
<tr><th>Setting</th><th>Values</th><th>Use it for</th></tr>
<tr><td><b>Base Color</b></td><td>any color</td><td>The main color.</td></tr>
<tr><td><b>Metallic</b></td><td>0 or 1</td><td>1 for metals (gold, steel), 0 for everything else. Values in between are rarely realistic.</td></tr>
<tr><td><b>Roughness</b></td><td>0 to 1</td><td>0 = mirror-like and glossy, 0.5 = satin, 1 = matte (chalk, fabric).</td></tr>
<tr><td><b>IOR</b></td><td>1.45 default</td><td>How strongly light bends; 1.33 water, 1.5 glass.</td></tr>
<tr><td><b>Alpha</b></td><td>0 to 1</td><td>Transparency for cut-outs like leaves.</td></tr>
<tr><td><b>Transmission Weight</b></td><td>0 or 1</td><td>1 with Roughness 0 makes clear <b>glass</b>.</td></tr>
<tr><td><b>Emission Color / Strength</b></td><td>color, 1&ndash;20</td><td>Glowing screens, lamps, lava.</td></tr>
<tr><td><b>Subsurface Weight</b></td><td>0 to 1</td><td>Light that shines through skin, wax, soap.</td></tr>
</table>
<h3>Recipes</h3>
<ul>
<li><b>Plastic</b>: any color, Metallic 0, Roughness 0.3.</li>
<li><b>Ceramic</b>: Metallic 0, Roughness 0.1&ndash;0.2.</li>
<li><b>Gold</b>: Base Color yellow-orange, Metallic 1, Roughness 0.2.</li>
<li><b>Rubber</b>: dark color, Roughness 0.8.</li>
<li><b>Glass</b>: Transmission 1, Roughness 0, white color.</li>
</ul>
<h3>Several materials on one object</h3>
<ol>
<li>In the Material tab click <b>+</b> next to the list to add a second <b>material slot</b>, then <b>New</b>.</li>
<li>In Edit Mode select the faces that should get it (for example the roof of a house).</li>
<li>With that slot selected in the list, click <b>Assign</b>.</li>
</ol>
<p>To reuse an existing material on another object, click the sphere dropdown next to New and pick it from the list.</p>
<div class="nasvet">The <b>Shading</b> workspace shows the same material as nodes in the Shader Editor. Every value in the Material tab is the same value on the Principled BSDF node.</div>
<h3>Try it</h3>
<p>Make three spheres side by side and give them gold, glass and red plastic materials. Compare them in Material Preview.</p>', 'img/lekcije/gif_materiali.gif', 1),

(4, 'Lighting a Scene', '<p>Lighting makes the difference between a flat and a beautiful render. Add lights with <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Light</b>. Their settings are in the green light-bulb tab in Properties.</p>
<h3>The four light types</h3>
<table class="tabela">
<tr><th>Type</th><th>Behaves like</th><th>Typical power</th></tr>
<tr><td><b>Point</b></td><td>a bare light bulb, shines in all directions</td><td>100&ndash;1000 W</td></tr>
<tr><td><b>Sun</b></td><td>sunlight: same direction everywhere, position does not matter, only rotation</td><td>Strength 2&ndash;5</td></tr>
<tr><td><b>Spot</b></td><td>a flashlight or stage spotlight (cone)</td><td>500&ndash;2000 W</td></tr>
<tr><td><b>Area</b></td><td>a softbox or window, gives soft studio light</td><td>200&ndash;1000 W</td></tr>
</table>
<p><b>Shadows:</b> a bigger <b>Radius</b> (Point, Spot), <b>Size</b> (Area) or <b>Angle</b> (Sun) makes softer shadows. Small values make sharp shadows.</p>
<h3>Three-point lighting (studio classic)</h3>
<ol>
<li><b>Key light</b>: the brightest Area light, 45&deg; to the side and above the object.</li>
<li><b>Fill light</b>: on the other side, about one third of the power, so shadows are not completely black.</li>
<li><b>Rim light</b>: behind the object, pointing at the camera; it draws a bright outline that separates the object from the background.</li>
</ol>
<p>To aim a light quickly: select it, press <kbd>R</kbd> twice for free rotation, or add an <b>Object Constraint &rarr; Track To</b> with your object as target.</p>
<h3>World light</h3>
<p>The <b>World</b> tab (red globe) controls the background and the light coming from the sky. Set <b>Color</b> for a simple sky. For realistic light, click the yellow dot next to Color, choose <b>Environment Texture</b> and open an <b>HDRI</b> image (free on Poly Haven). The HDRI lights your scene like a real place.</p>
<h3>Light color</h3>
<p>Warm (orange) key light + cool (blue) fill light looks natural and cinematic. Keep colors subtle.</p>
<div class="nasvet">Use the <b>Rendered</b> viewport shading (<kbd>Z</kbd> &rarr; Rendered) while you place lights, so you see the result live.</div>
<h3>Try it</h3>
<p>Delete the default light, add a Sun with Strength 3 and rotate it so shadows fall diagonally. Then add an Area light as a rim light behind your object.</p>', 'img/lekcije/luci.jpg', 2),

(4, 'Camera and Rendering', '<h3>Set up the camera</h3>
<ul>
<li><kbd>Numpad 0</kbd> looks through the active camera.</li>
<li>The easiest way to place it: navigate the viewport to a nice view, then press <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd>. The camera jumps to your view.</li>
<li>For fine-tuning open the Sidebar (<kbd>N</kbd>) &rarr; <b>View</b> tab &rarr; enable <b>Lock Camera to View</b>. Now orbiting and panning moves the camera itself. Turn it off when you are done.</li>
<li>In the camera settings (green camera tab) <b>Focal Length</b> 50 mm looks natural, 85 mm is good for portraits and products, 24 mm is wide for rooms and landscapes.</li>
</ul>
<h3>Choose a render engine</h3>
<p>In the <b>Render</b> tab (camera back icon):</p>
<ul>
<li><b>EEVEE</b>: real-time, renders in seconds. Great for stylized looks, animation and previews.</li>
<li><b>Cycles</b>: path tracing, slower but physically correct light, reflections and glass. Set <b>Render &rarr; Max Samples</b> to about 128 and leave <b>Denoise</b> on. If you have a graphics card, go to Edit &rarr; Preferences &rarr; System, enable it, then set <b>Device: GPU Compute</b>.</li>
</ul>
<h3>Resolution and output</h3>
<p>In the <b>Output</b> tab (printer icon) set Resolution X 1920 and Y 1080. Lower the <b>%</b> slider to 50 for quick test renders.</p>
<h3>Render and save</h3>
<ol>
<li>Press <kbd>F12</kbd>. A new window shows the image being rendered.</li>
<li>In that window choose <b>Image &rarr; Save As</b> and save as PNG. Nothing is saved automatically!</li>
<li><kbd>F11</kbd> shows the last render again if you closed the window.</li>
</ol>
<h3>Make it look better</h3>
<ul>
<li>In Render &rarr; <b>Color Management</b>, <b>View Transform AgX</b> (Filmic in older versions) handles bright lights nicely. <b>Look</b> adds contrast.</li>
<li>A floor plane under the object (and maybe a curved backdrop) gives you soft contact shadows.</li>
<li><kbd>Ctrl</kbd>+<kbd>F12</kbd> renders an animation; set the output folder in the Output tab first.</li>
</ul>
<div class="nasvet">Composition rule of thirds: in the camera view, open the Camera tab &rarr; Viewport Display &rarr; Composition Guides &rarr; Thirds, and put your object on one of the lines.</div>
<h3>Try it</h3>
<p>Set your camera with <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd>, render once in EEVEE and once in Cycles, and compare how long each took and how the shadows look.</p>', 'img/lekcije/projekt_scena.jpg', 3),

(5, 'Sculpt Mode and Brushes', '<p>Sculpting is like modeling with clay: you push, pull and smooth the surface with brushes instead of moving single vertices. It is best for organic shapes such as characters, animals, rocks and food.</p>
<h3>Get started</h3>
<ol>
<li>Add a <b>UV Sphere</b> or use the <b>Sculpting</b> workspace, which already gives you a high-resolution sphere.</li>
<li>Switch the mode to <b>Sculpt Mode</b> (mode dropdown in the top-left of the viewport).</li>
<li>Your object needs enough geometry. If strokes look blocky, see the next lesson (Remesh).</li>
</ol>
<h3>The brushes beginners need</h3>
<table class="tabela">
<tr><th>Brush</th><th>What it does</th></tr>
<tr><td><b>Draw</b></td><td>raises the surface along the stroke. Basic shapes and lines.</td></tr>
<tr><td><b>Clay Strips</b></td><td>adds flat layers of "clay". The best brush for building up forms such as cheeks and muscles.</td></tr>
<tr><td><b>Grab</b></td><td>drags a big area like soft rubber. Use it first to get the overall shape right.</td></tr>
<tr><td><b>Smooth</b></td><td>flattens bumps. Hold <kbd>Shift</kbd> with any brush to smooth temporarily.</td></tr>
<tr><td><b>Inflate</b></td><td>puffs the surface up like a balloon, great for cheeks, lips and fingers.</td></tr>
<tr><td><b>Crease</b></td><td>makes sharp grooves: eyelids, wrinkles, the line of the mouth.</td></tr>
<tr><td><b>Snake Hook</b></td><td>pulls out long shapes like horns, ears or tentacles.</td></tr>
<tr><td><b>Mask</b></td><td>paints a mask; masked areas cannot change. <kbd>Alt</kbd>+<kbd>M</kbd> clears the mask, <kbd>Ctrl</kbd>+<kbd>I</kbd> inverts it.</td></tr>
</table>
<h3>Brush controls</h3>
<ul>
<li><kbd>F</kbd> brush radius, <kbd>Shift</kbd>+<kbd>F</kbd> strength.</li>
<li>Hold <kbd>Ctrl</kbd> to invert the brush (Draw then digs in instead of raising).</li>
<li><b>Symmetry</b>: in the header the X axis is on by default for symmetric models. Turn it off for asymmetric details.</li>
<li>With a tablet enable pressure for radius and strength.</li>
</ul>
<h3>The right order</h3>
<ol>
<li><b>Big shapes first</b> with Grab and a large radius. Look from the front, side and top views.</li>
<li><b>Medium forms</b> with Clay Strips and Inflate.</li>
<li><b>Smooth</b> often (<kbd>Shift</kbd>).</li>
<li><b>Details last</b> with Crease and a small Draw brush.</li>
</ol>
<div class="nasvet">Turn on the <b>Matcap</b> view: viewport shading Solid &rarr; dropdown &rarr; Lighting: MatCap. The shiny clay look shows every bump and makes sculpting much easier.</div>
<h3>Try it</h3>
<p>Sculpt a simple stone: start from a sphere, Grab to make it uneven, Clay Strips for flat faces, Crease for cracks, Smooth to finish.</p>', 'img/lekcije/kiparjenje.jpg', 1),

(5, 'Remesh, Dyntopo and Multires', '<p>A sculpt can only show as much detail as it has polygons. These three tools control the resolution.</p>
<h3>Voxel Remesh (start here)</h3>
<p>Rebuilds the whole mesh with an even grid of polygons, as if you melted the clay and formed it again.</p>
<ul>
<li>In Sculpt Mode press <kbd>R</kbd> and move the mouse to set the <b>Voxel Size</b> (a grid preview shows the size), then <kbd>Ctrl</kbd>+<kbd>R</kbd> to remesh. You can also set Voxel Size in the <b>Remesh</b> panel in the header.</li>
<li>Smaller voxel size = more detail = slower. Start big (0.05&ndash;0.1), go smaller as you add details.</li>
<li>Remesh after big Grab or Snake Hook moves, which stretch the polygons.</li>
</ul>
<h3>Dyntopo (Dynamic Topology)</h3>
<p>Enable it in the header (Dyntopo checkbox). Now the brush adds polygons only where you paint, automatically. Set <b>Detail Size</b> smaller for finer strokes. Great for sketching shapes with Snake Hook; the downside is messy triangle topology.</p>
<h3>Multiresolution modifier (for fine details)</h3>
<p>Add <b>Multires</b> in the Modifiers tab and click <b>Subdivide</b> a few times. You keep a simple base mesh but sculpt fine details (skin pores, scales, fabric) on the higher levels. You can go back to a lower level to change big shapes without losing the details.</p>
<h3>Which one when?</h3>
<table class="tabela">
<tr><th>Stage</th><th>Use</th></tr>
<tr><td>Blocking out the shape</td><td>Voxel Remesh (big voxels) or Dyntopo</td></tr>
<tr><td>Medium forms</td><td>Voxel Remesh with smaller voxels</td></tr>
<tr><td>Fine details on a finished shape</td><td>Multires</td></tr>
</table>
<div class="nasvet">Watch the polygon count (Overlays &rarr; Statistics). A few hundred thousand faces is fine on most computers. If Blender gets slow, use a bigger voxel size.</div>
<h3>Try it</h3>
<p>Sculpt a cartoon head: a sphere, Remesh with voxel 0.05, Grab for the jaw, Snake Hook for the ears, Remesh again with 0.02, then Crease for the eyes and mouth.</p>', 'img/lekcije/gif_kiparjenje.gif', 2),

(6, 'Project 1: Coffee Mug', '<p><b>What you build:</b> a smooth coffee mug with a handle and coffee inside. <b>You practice:</b> adding objects, the Adjust Last Operation panel, inset, extrude, Subdivision Surface, support loops, materials. <b>Time:</b> about 30 minutes.</p>
<p class="nasvet">Every step shows what your screen should look like. Orange = what you have selected at that moment. Stuck? Compare with the finished file: <a href="files/mug_finished.blend" download>mug_finished.blend</a> (made in Blender 5.0).</p>
<div class="korak-projekta"><div class="korak-st">1</div><div class="korak-vsebina"><h3>Add a cylinder</h3>
<ol><li>Start a new file (File &rarr; New &rarr; General). Click the cube and press <kbd>X</kbd> &rarr; Delete.</li>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cylinder</b>.</li>
<li>Open the <b>Adjust Last Operation</b> panel in the bottom-left corner and set <b>Vertices: 24</b>, <b>Radius: 1 m</b>, <b>Depth: 2 m</b>, <b>Location Z: 1 m</b> (so it stands on the floor).</li></ol><img class="slika-koraka" src="img/projekti/mug_1.jpg" alt="Step 1: Add a cylinder" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">2</div><div class="korak-vsebina"><h3>Inset the top face</h3>
<ol><li>Press <kbd>Tab</kbd> for Edit Mode, then <kbd>3</kbd> for face select.</li>
<li>Click the <b>top face</b> to select only it (it turns orange).</li>
<li>Press <kbd>I</kbd>, type <kbd>0</kbd><kbd>.</kbd><kbd>1</kbd><kbd>5</kbd> and press <kbd>Enter</kbd>. A ring appears: that will be the rim (wall thickness) of the mug.</li></ol><img class="slika-koraka" src="img/projekti/mug_2.jpg" alt="Step 2: Inset the top face" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">3</div><div class="korak-vsebina"><h3>Extrude down to hollow it out</h3>
<ol><li>Keep the inner face selected. Press <kbd>E</kbd>, type <kbd>-</kbd><kbd>1</kbd><kbd>.</kbd><kbd>8</kbd>, press <kbd>Enter</kbd>.</li>
<li>The face moves 1.8 m down into the mug. The mug is now hollow with a 0.2 m thick bottom.</li>
<li>Orbit (middle mouse) and look inside to check.</li></ol><img class="slika-koraka" src="img/projekti/mug_3.jpg" alt="Step 3: Extrude down to hollow it out" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">4</div><div class="korak-vsebina"><h3>Make it smooth</h3>
<ol><li>Press <kbd>Tab</kbd> to go back to Object Mode.</li>
<li>Press <kbd>Ctrl</kbd>+<kbd>2</kbd>. This adds a <b>Subdivision Surface</b> modifier with level 2 (you can see it in the wrench tab).</li>
<li>Right click &rarr; <b>Shade Smooth</b>.</li>
<li>The mug is smooth now, but it looks soft and blobby like a bowl. The next step fixes that.</li></ol><img class="slika-koraka" src="img/projekti/mug_4.jpg" alt="Step 4: Make it smooth" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">5</div><div class="korak-vsebina"><h3>Add support loops for crisp edges</h3>
<ol><li><kbd>Tab</kbd> into Edit Mode. Press <kbd>Ctrl</kbd>+<kbd>R</kbd> and hover over a vertical edge on the <b>outside</b> wall. Left click, then slide the yellow line close to the <b>top</b> and left click again.</li>
<li>Do the same for a loop close to the <b>bottom</b> of the outside wall.</li>
<li>Look into the mug and add two more loop cuts on the <b>inside</b> wall: one near the rim and one near the inner bottom.</li>
<li><kbd>Tab</kbd> back. The walls are now straight and the edges are only slightly rounded, like a real mug.</li></ol><img class="slika-koraka" src="img/projekti/mug_5.jpg" alt="Step 5: Add support loops for crisp edges" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">6</div><div class="korak-vsebina"><h3>Add the handle</h3>
<ol><li>In Object Mode press <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Torus</b>.</li>
<li>In Adjust Last Operation set <b>Major Radius 0.55</b>, <b>Minor Radius 0.1</b>, <b>Location X 1.52</b>, <b>Z 1</b> and <b>Rotation X 90&deg;</b>. The ring now stands upright on the side of the mug.</li>
<li>Press <kbd>S</kbd> <kbd>Z</kbd> <kbd>1</kbd><kbd>.</kbd><kbd>2</kbd><kbd>5</kbd> <kbd>Enter</kbd> to make it a bit taller, then right click &rarr; <b>Shade Smooth</b>.</li>
<li>Check from the top view (<kbd>Numpad 7</kbd>) that the handle does not poke into the inside of the mug. If it does, move it out a little with <kbd>G</kbd> <kbd>X</kbd>.</li></ol><img class="slika-koraka" src="img/projekti/mug_6.jpg" alt="Step 6: Add the handle" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">7</div><div class="korak-vsebina"><h3>Coffee and materials</h3>
<ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Circle</b>. In Adjust Last Operation set <b>Radius 0.86</b>, <b>Fill Type: N-Gon</b> and <b>Location Z 1.6</b>. This is the coffee surface.</li>
<li>Select the mug, Material tab &rarr; <b>New</b>, name it <code>Ceramic</code>, choose a Base Color and set <b>Roughness 0.15</b>.</li>
<li>Select the handle, click the sphere dropdown in the Material tab and pick <b>Ceramic</b>, so both use the same material.</li>
<li>Select the coffee circle &rarr; New material <code>Coffee</code>: very dark brown, Roughness 0.05 (shiny liquid).</li>
<li>Press <kbd>Z</kbd> &rarr; Material Preview to check.</li></ol><img class="slika-koraka" src="img/projekti/mug_7.jpg" alt="Step 7: Coffee and materials" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">8</div><div class="korak-vsebina"><h3>Light, camera, render</h3>
<ol><li>Add a floor: <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Plane, <kbd>S</kbd> <kbd>2</kbd><kbd>0</kbd> <kbd>Enter</kbd>, give it a wood-colored material.</li>
<li>Delete the default light and add an <b>Area</b> light, Power 600 W, Size 4 m, above and to the side of the mug.</li>
<li>Find a nice view, then <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd> to move the camera there.</li>
<li>Render tab: Cycles, Max Samples 128. Press <kbd>F12</kbd> and save with Image &rarr; Save As.</li></ol><img class="slika-koraka" src="img/projekti/mug_8.jpg" alt="Step 8: Light, camera, render" loading="lazy"></div></div>
<h3>Bonus challenge</h3>
<p>Unwrap the mug and paint a stripe or your name on it, using the Texture Painting lesson.</p>
<p>When you are happy, mark this lesson as done and upload your render to the <a href="galerija.php">gallery</a>!</p>', 'img/projekti/mug_8.jpg', 1),

(6, 'Project 2: Cute Cottage', '<p><b>What you build:</b> a cute cottage with a tiled roof, a chimney with smoke puffs, an arched door, windows, steps, a stone path and two low-poly trees on a grass platform. <b>You practice:</b> typing exact positions and sizes, applying scale, the Bevel and Array modifiers, joining objects, duplicating, and materials with hex colors. <b>Time:</b> about 1&ndash;2 hours. Take breaks and save often with <kbd>Ctrl</kbd>+<kbd>S</kbd>.</p>
<p class="nasvet">In every picture the parts you add in that step are <b>orange</b>. All sizes are copied from the original model, so your cottage will look exactly like the finished one. Finished file to compare: <a href="files/cute_house_finished.blend" download>cute_house_finished.blend</a> (made in Blender 5.0).</p>
<h3>Before you start: how to read the numbers</h3>
<p>Every part is placed with two sets of numbers that you type into the <b>Sidebar</b> (press <kbd>N</kbd> in the 3D Viewport, then the <b>Item</b> tab):</p>
<ul>
<li><b>Location X, Y, Z</b> is where the <b>center</b> of the part is. X goes left (&minus;) to right (+), Y goes front (&minus;) to back (+), Z goes down to up. The front of the cottage faces &minus;Y, which is the view you get with <kbd>Numpad 1</kbd>.</li>
<li><b>Dimensions X, Y, Z</b> is the full <b>width, depth and height</b> of the part.</li>
</ul>
<p>Because Location is the center, the bottom of a part is at <i>Z minus half the height</i> and the top is at <i>Z plus half the height</i>. Example: the walls have Z <code>0.85</code> and height <code>1.4</code>, so they go from 0.85 &minus; 0.7 = <b>0.15</b> to 0.85 + 0.7 = <b>1.55</b>. Every "Why these numbers?" box below uses this trick, so you understand how the parts fit together instead of just copying.</p>
<p><b>Start clean:</b> open Blender, choose <b>File &rarr; New &rarr; General</b>, then press <kbd>A</kbd> (select all) and <kbd>X</kbd> &rarr; <b>Delete</b> to remove the default cube, camera and light. We add a new camera and light at the end.</p>
<div class="korak-projekta"><div class="korak-st">1</div><div class="korak-vsebina"><h3>Grass platform</h3><ol><li>Press <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>Cube</b>. A cube appears at the 3D cursor (the red-white ring in the middle of the scene). It is 2 m big for now; we give it the right size next.</li><li>Press <kbd>N</kbd> to open the <b>Sidebar</b> on the right of the viewport and click its <b>Item</b> tab. You see three groups of fields: Location, Rotation and Dimensions.</li><li>Under <b>Location</b>: click the <b>X</b> field, type <code>0</code>, press <kbd>Tab</kbd> to jump to Y, type <code>-0.05</code>, <kbd>Tab</kbd>, type <code>0.075</code> in Z and press <kbd>Enter</kbd>. The cube jumps to its place.</li><li>Under <b>Dimensions</b> type X <code>3.4</code>, <kbd>Tab</kbd>, Y <code>3.3</code>, <kbd>Tab</kbd>, Z <code>0.15</code>, <kbd>Enter</kbd>. Dimensions is the full size of the box in meters: width (X), depth (Y) and height (Z).</li><li>Press <kbd>Ctrl</kbd>+<kbd>A</kbd> with the mouse over the viewport and choose <b>Scale</b>. Typing Dimensions secretly changed the <b>Scale</b> values; this resets them to 1 while the box keeps its size. Without this, the bevel in the next step would come out stretched.</li><li>Round the edges: in the Properties editor (bottom right) click the blue <b>wrench</b> tab (Modifiers) &rarr; <b>Add Modifier</b> &rarr; <b>Generate</b> &rarr; <b>Bevel</b>. In the Bevel panel set <b>Amount</b> to <code>0.05</code> and <b>Segments</b> to <code>3</code>.</li><li>Right-click the object in the viewport &rarr; <b>Shade Auto Smooth</b>. The rounded edges now look smooth, but the flat sides stay flat.</li><li>Press <kbd>F2</kbd>, type the name <code>Grass</code> and press <kbd>Enter</kbd>, so you can find it later in the Outliner (top right).</li></ol><p><b>Why these numbers?</b> The platform is 0.15 m thick and its center is at Z 0.075, which is exactly half of 0.15. So its bottom is at 0 (on the floor grid) and its top is at <b>0.15</b>. Everything else will stand on Z 0.15. Y is &minus;0.05 to shift the platform a little toward the front, where the path will go.</p><p><b>Check:</b> press <kbd>Numpad 1</kbd> (front view). The bottom of the platform sits exactly on the red horizontal line of the grid.</p><img class="slika-koraka" src="img/projekti/cute_1.jpg" alt="Step 1: Grass platform" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">2</div><div class="korak-vsebina"><h3>Walls and the blue plinth (the band around the bottom)</h3><p><b>2a. The walls</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0</code>, Y <code>0.1</code>, Z <code>0.85</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>1.6</code>, Y <code>1.4</code>, Z <code>1.4</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.04</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Walls</code> and press <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> height 1.4 with center 0.85 means the walls go from <b>0.15</b> (standing on the grass) to <b>1.55</b>. Y 0.1 moves the house 10 cm backward to leave room in front for the steps. The front of the walls is at Y 0.1 &minus; 1.4/2 = <b>&minus;0.6</b>; remember that number, the door goes there.</p><p><b>2b. The plinth</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0</code>, Y <code>0.1</code>, Z <code>0.25</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>1.66</code>, Y <code>1.46</code>, Z <code>0.2</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.03</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Plinth</code> and press <kbd>Enter</kbd>.</li></ol>
<p><b>How does the plinth stick out at the bottom?</b> It is a second box that is a little <b>bigger</b> than the walls and wraps around their lower part like a belt:</p>
<ul>
<li>It has the <b>same center X and Y</b> as the walls (0 and 0.1). So it is centered around them and the extra size is shared equally on both sides.</li>
<li>It is <b>1.66</b> wide instead of 1.6. That is 6 cm more, which means <b>3 cm sticks out on the left and 3 cm on the right</b>. The depth 1.46 instead of 1.4 does the same at the front and back.</li>
<li>It is only <b>0.2</b> high with center Z <b>0.25</b>, so it goes from 0.15 (the grass) to 0.35. It covers the bottom 20 cm of the walls.</li>
<li>The part of the walls inside the plinth is simply hidden. Overlapping objects are completely normal in this kind of model; you never see the inside.</li>
</ul><p><b>Check:</b> press <kbd>Z</kbd> &rarr; <b>Wireframe</b>. You can see the wall lines continue down inside the plinth, and the plinth outline 3 cm outside the walls. Press <kbd>Z</kbd> &rarr; <b>Solid</b> to go back.</p><img class="slika-koraka" src="img/projekti/cute_2.jpg" alt="Step 2: Walls and the blue plinth (the band around the bottom)" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">3</div><div class="korak-vsebina"><h3>The gable (the triangle under the roof)</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0</code>, Y <code>0.1</code>, Z <code>1.92</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>1.58</code>, Y <code>1.38</code>, Z <code>0.76</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Gable</code> and press <kbd>Enter</kbd>.</li></ol>
<p>Now turn the box into a triangle:</p>
<ol>
<li>With the Gable selected press <kbd>Tab</kbd>. You are now in <b>Edit Mode</b>: you see the vertices and edges of the box.</li>
<li>Press <kbd>3</kbd> (the 3 above the letters, not on the numpad) for <b>face select</b>. Press <kbd>Alt</kbd>+<kbd>A</kbd> to deselect everything.</li>
<li>Orbit the view (hold the middle mouse button and drag) until you see the top, then <b>click the top face</b>. Only that face should be orange.</li>
<li>Type <kbd>S</kbd> <kbd>X</kbd> <kbd>0</kbd> <kbd>Enter</kbd>. This means "scale only along X to size 0". The four corners of the top face slide together to the middle line, which becomes the ridge of the roof, and the box turns into a triangle prism.</li>
<li>Each pair of corners is now on top of each other. Press <kbd>A</kbd> to select all, then <kbd>M</kbd> &rarr; <b>By Distance</b>. The status bar at the bottom says "Removed 2 vertice(s)".</li>
<li>Press <kbd>Tab</kbd> to go back to Object Mode.</li>
</ol><p><b>Why these numbers?</b> height 0.76 with center 1.92 means the gable goes from <b>1.54</b> to <b>2.30</b>. It starts 1 cm below the top of the walls (1.55), so there is no gap between them. It is 1.58 wide, 2 cm narrower than the walls, so it does not poke out past the rounded wall edges. The slope rises 0.76 over half the width (0.79), which is about <b>44&deg;</b>. That is why the roof in the next step is tilted by exactly 44&deg;.</p><img class="slika-koraka" src="img/projekti/cute_3.jpg" alt="Step 3: The gable (the triangle under the roof)" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">4</div><div class="korak-vsebina"><h3>Two roof slabs</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>-0.51</code>, Y <code>0.1</code>, Z <code>1.91</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li>Under <b>Rotation</b> type Y <code>-44</code> and press <kbd>Enter</kbd>. The box tilts.</li><li><b>Dimensions</b> X <code>1.36</code>, Y <code>1.74</code>, Z <code>0.12</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.03</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Roof_Left</code> and press <kbd>Enter</kbd>.</li></ol>
<p><b>The right slab is a mirrored copy:</b></p>
<ol>
<li>With Roof_Left selected press <kbd>Shift</kbd>+<kbd>D</kbd> (duplicate). The copy is attached to your mouse; <b>right-click</b> to drop it in the same place.</li>
<li>In the Sidebar change only two fields: <b>Location X</b> to <code>0.51</code> (the minus disappears, so it moves to the right side) and <b>Rotation Y</b> to <code>44</code> (tilted the other way).</li>
<li>Press <kbd>F2</kbd> and name it <code>Roof_Right</code>. The bevel was copied too.</li>
</ol><p><b>Why these numbers?</b> Rotation Y &minus;44 tilts the slab to match the 44&deg; slope of the gable. The Dimensions are measured along the tilted box itself: 1.36 m along the slope, which is longer than the slope, so the roof hangs over the wall at the bottom (the eaves). 1.74 m deep is 36 cm more than the house (1.38), so it overhangs 18 cm at the front and at the back. 0.12 m is the thickness. X &minus;0.51 and Z 1.91 put the middle of the slab on the middle of the left slope.</p><p><b>Check:</b> in the front view (<kbd>Numpad 1</kbd>) the two slabs form an upside-down V that meets at the top, with the triangle of the gable fully hidden underneath.</p><img class="slika-koraka" src="img/projekti/cute_4.jpg" alt="Step 4: Two roof slabs" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">5</div><div class="korak-vsebina"><h3>Shingles with the Array modifier, and the ridge</h3><p><b>5a. One shingle strip</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>-0.911</code>, Y <code>0.1</code>, Z <code>1.637</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li>Under <b>Rotation</b> type Y <code>-44</code> and press <kbd>Enter</kbd>. The box tilts.</li><li><b>Dimensions</b> X <code>0.24</code>, Y <code>1.68</code>, Z <code>0.04</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Shingles_Left</code> and press <kbd>Enter</kbd>.</li></ol>
<p>The strip now lies on the lower edge of the left roof slab. Do <b>not</b> add the bevel yet.</p>
<p><b>5b. Copy it up the roof with Array</b></p>
<ol>
<li>Wrench tab &rarr; <b>Add Modifier</b> &rarr; <b>Generate</b> &rarr; <b>Array</b>.</li>
<li>Set <b>Count</b> to <code>4</code>. You now see 4 strips side by side.</li>
<li>Open <b>Relative Offset</b> and <b>untick</b> it. Tick <b>Constant Offset</b>, open it and set <b>Distance X</b> to <code>0.27</code>. The strips spread out with small gaps between them and climb up the roof.</li>
<li>Now add the <b>Bevel</b> modifier (Amount <code>0.015</code>, Segments <code>2</code>) and Shade Auto Smooth. In the modifier list Array must be <b>above</b> Bevel, so every strip gets rounded edges. If the order is wrong, drag Bevel down by its handle (the dots on the right of its header).</li>
</ol>
<p><b>Why does it climb up the roof?</b> Array copies the object along the object''s own X axis. Because we rotated the strip by &minus;44&deg;, its X axis points up the slope. Relative Offset would place the copies exactly touching (0.24 m apart); Constant Offset 0.27 m leaves a 3 cm gap so you can see each tile row.</p>
<p><b>5c. Right side</b></p>
<ol>
<li><kbd>Shift</kbd>+<kbd>D</kbd>, right-click. In the Sidebar set <b>Location X</b> <code>0.911</code> and <b>Rotation Y</b> <code>44</code>.</li>
<li>In its Array modifier change <b>Distance X</b> to <code>-0.27</code>. On the right side the strip''s X axis points <i>down</i> the roof, so we need a negative distance to go up.</li>
</ol>
<p><b>5d. The ridge</b></p>
<ol>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cylinder</b>.</li>
<li>Open the <b>Adjust Last Operation</b> panel in the bottom-left corner of the viewport (click its title if it is folded). Set <b>Radius</b> <code>0.06</code>, <b>Depth</b> <code>1.74</code>, <b>Location</b> <code>0</code>, <code>0.1</code>, <code>2.44</code> and <b>Rotation X</b> <code>90</code>.</li>
<li>Right-click &rarr; <b>Shade Smooth</b>. Name it <code>Ridge</code>.</li>
</ol><p><b>Why these numbers?</b> a cylinder normally stands upright; Rotation X 90 lays it on its side along the Y axis. Its length (Depth 1.74) is the same as the roof, and Z 2.44 is the top where the two slabs meet, so the ridge covers the joint.</p><img class="slika-koraka" src="img/projekti/cute_5.jpg" alt="Step 5: Shingles with the Array modifier, and the ridge" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">6</div><div class="korak-vsebina"><h3>Chimney with smoke puffs</h3><p><b>6a. The chimney stack</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.42</code>, Y <code>0.42</code>, Z <code>2.13</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.26</code>, Y <code>0.26</code>, Z <code>0.62</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.015</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Chimney</code> and press <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> X 0.42 and Y 0.42 put the chimney on the right roof slope, toward the back. It goes from 2.13 &minus; 0.31 = 1.82 to 2.13 + 0.31 = <b>2.44</b>. The lower part is hidden inside the roof, exactly like a real chimney.</p><p><b>6b. The cap on top</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.42</code>, Y <code>0.42</code>, Z <code>2.48</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.34</code>, Y <code>0.34</code>, Z <code>0.08</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.015</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Chimney_Cap</code> and press <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> the cap goes from 2.44 to 2.52, so it sits exactly on top of the stack. It is 0.34 wide instead of 0.26, so it sticks out 4 cm on every side: the same "bigger box" trick as the plinth.</p><p><b>6c. Three blue bands with Array</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.42</code>, Y <code>0.42</code>, Z <code>2.04</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.28</code>, Y <code>0.28</code>, Z <code>0.025</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Chimney_Bands</code> and press <kbd>Enter</kbd>.</li></ol>
<ol><li>Add an <b>Array</b> modifier: Count <code>3</code>, untick Relative Offset, tick Constant Offset, <b>Distance Z</b> <code>0.12</code>. You get bands at Z 2.04, 2.16 and 2.28.</li></ol>
<p>The bands are 0.28 wide, 2 cm more than the stack, so they stick out 1 cm all around.</p>
<p><b>6d. Smoke puffs</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.44</code>, Y <code>0.42</code>, Z <code>2.66</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.08</code>, Y <code>0.08</code>, Z <code>0.08</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.015</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Smoke_1</code> and press <kbd>Enter</kbd>.</li></ol><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.5</code>, Y <code>0.42</code>, Z <code>2.8</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.05</code>, Y <code>0.05</code>, Z <code>0.05</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.01</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Smoke_2</code> and press <kbd>Enter</kbd>.</li></ol><p>Each puff is a little higher, smaller and further to the right, so they look like smoke drifting away.</p><img class="slika-koraka" src="img/projekti/cute_6.jpg" alt="Step 6: Chimney with smoke puffs" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">7</div><div class="korak-vsebina"><h3>Arched door and mailbox</h3>
<p>An arch is a <b>box with a cylinder on top</b>. The cylinder''s radius is half the width of the box, and its center is placed exactly on the top edge of the box, so only the round upper half shows.</p>
<p><b>7a. Door frame (blue)</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0</code>, Y <code>-0.62</code>, Z <code>0.595</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.58</code>, Y <code>0.06</code>, Z <code>0.59</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Door_Frame</code> and press <kbd>Enter</kbd>.</li></ol>
<ol>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cylinder</b>. In Adjust Last Operation: <b>Radius</b> <code>0.29</code> (half of 0.58), <b>Depth</b> <code>0.055</code>, <b>Location</b> <code>0</code>, <code>-0.62</code>, <code>0.89</code>, <b>Rotation X</b> <code>90</code> (so the round side faces the front).</li>
<li>Join them into one object: the cylinder is selected; now <kbd>Shift</kbd>+click the frame box so it becomes the <b>active</b> object (lighter orange outline). Press <kbd>Ctrl</kbd>+<kbd>J</kbd>. Now it is one object called Door_Frame.</li>
</ol><p><b>Why these numbers?</b> the front of the walls is at Y &minus;0.6. The frame is 0.06 deep with center &minus;0.62, so it goes from &minus;0.65 to &minus;0.59: 1 cm inside the wall and 5 cm sticking out. The box goes from Z 0.30 to 0.89, and 0.89 is exactly where the cylinder center is. The cylinder is 5 mm thinner (0.055) than the box on purpose: if two faces lie exactly on top of each other, you get flickering black spots called <b>z-fighting</b>.</p><p><b>7b. The door (wood)</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0</code>, Y <code>-0.645</code>, Z <code>0.58</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.44</code>, Y <code>0.05</code>, Z <code>0.56</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Door</code> and press <kbd>Enter</kbd>.</li></ol>
<ol>
<li>Add a <b>Cylinder</b>: Radius <code>0.22</code>, Depth <code>0.045</code>, Location <code>0</code>, <code>-0.645</code>, <code>0.86</code>, Rotation X <code>90</code>.</li>
<li>Click the cylinder, <kbd>Shift</kbd>+click the door box, <kbd>Ctrl</kbd>+<kbd>J</kbd>.</li>
</ol>
<p>The door is narrower (0.44) than the frame (0.58), so 7 cm of blue frame shows on each side, and it sits 2.5 cm in front of the frame.</p>
<p><b>7c. Small window, knob and mailbox</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0</code>, Y <code>-0.675</code>, Z <code>0.895</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.12</code>, Y <code>0.01</code>, Z <code>0.17</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Door_Window</code> and press <kbd>Enter</kbd>.</li></ol>
<ol><li>Knob: <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>UV Sphere</b>, in Adjust Last Operation <b>Radius</b> <code>0.025</code>, <b>Location</b> <code>0.145</code>, <code>-0.69</code>, <code>0.67</code>. Right-click &rarr; Shade Smooth.</li></ol><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.52</code>, Y <code>-0.63</code>, Z <code>0.77</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.2</code>, Y <code>0.06</code>, Z <code>0.06</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.01</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Mailbox</code> and press <kbd>Enter</kbd>.</li></ol><img class="slika-koraka" src="img/projekti/cute_7.jpg" alt="Step 7: Arched door and mailbox" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">8</div><div class="korak-vsebina"><h3>Steps and a stone path</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0</code>, Y <code>-0.69</code>, Z <code>0.23</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.58</code>, Y <code>0.18</code>, Z <code>0.16</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.015</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Step_Upper</code> and press <kbd>Enter</kbd>.</li></ol><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0</code>, Y <code>-0.77</code>, Z <code>0.19</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.72</code>, Y <code>0.34</code>, Z <code>0.08</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.015</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Step_Lower</code> and press <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> both steps start on the grass (Z 0.15). The upper step is 0.16 high (top at 0.31, right under the door) and touches the wall at Y &minus;0.6. The lower step is only 0.08 high but wider (0.72) and deeper (0.34), so it sticks out in front of and beside the upper step. Two boxes of different sizes stacked like this always make a staircase.</p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0</code>, Y <code>-1.02</code>, Z <code>0.165</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.5</code>, Y <code>0.24</code>, Z <code>0.03</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.01</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Stone_1</code> and press <kbd>Enter</kbd>.</li></ol>
<p><b>Two more stones by duplicating:</b></p>
<ol>
<li>With Stone_1 selected type <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>Y</kbd> <kbd>-0.31</kbd> <kbd>Enter</kbd>. The copy moves 31 cm toward the front.</li>
<li>Type <kbd>G</kbd> <kbd>X</kbd> <kbd>0.04</kbd> <kbd>Enter</kbd> to nudge it 4 cm to the right.</li>
<li>Duplicate that one: <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>Y</kbd> <kbd>-0.31</kbd> <kbd>Enter</kbd>, then <kbd>G</kbd> <kbd>X</kbd> <kbd>-0.06</kbd> <kbd>Enter</kbd>.</li>
</ol>
<p>The small sideways nudges make the path look hand-made instead of perfectly straight. The stones are only 3 cm thick and sit right on the grass (0.15 to 0.18).</p><img class="slika-koraka" src="img/projekti/cute_8.jpg" alt="Step 8: Steps and a stone path" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">9</div><div class="korak-vsebina"><h3>Side window</h3>
<p>The window is on the right wall. The right wall surface is at X <b>0.8</b> (half of the 1.6 m width). All window parts have X around 0.8 so they sit on that wall. Press <kbd>Numpad 3</kbd> (right view) to look straight at it while you work.</p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.805</code>, Y <code>0.05</code>, Z <code>0.97</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.02</code>, Y <code>0.5</code>, Z <code>0.5</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Window_Glass</code> and press <kbd>Enter</kbd>.</li></ol>
<p><b>The frame: 4 bars around the glass</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.82</code>, Y <code>0.05</code>, Z <code>0.72</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.04</code>, Y <code>0.56</code>, Z <code>0.06</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Frame_Bottom</code> and press <kbd>Enter</kbd>.</li></ol>
<ol>
<li>Top bar: with Frame_Bottom selected type <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>Z</kbd> <kbd>0.5</kbd> <kbd>Enter</kbd>. Name it <code>Frame_Top</code>.</li>
</ol><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.82</code>, Y <code>-0.2</code>, Z <code>0.97</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.04</code>, Y <code>0.06</code>, Z <code>0.44</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Frame_Left</code> and press <kbd>Enter</kbd>.</li></ol>
<ol>
<li>Right bar: <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>Y</kbd> <kbd>0.5</kbd> <kbd>Enter</kbd>. Name it <code>Frame_Right</code>.</li>
</ol>
<p>The side bars are only 0.44 high, so they fit exactly <i>between</i> the top and bottom bars without overlapping (overlapping flat faces would flicker).</p>
<p><b>The cross in the middle</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.82</code>, Y <code>0.05</code>, Z <code>0.97</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.04</code>, Y <code>0.44</code>, Z <code>0.04</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Bar_Horizontal</code> and press <kbd>Enter</kbd>.</li></ol><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.82</code>, Y <code>0.05</code>, Z <code>0.97</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.035</code>, Y <code>0.04</code>, Z <code>0.44</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Bar_Vertical</code> and press <kbd>Enter</kbd>.</li></ol>
<p>Both bars have the same center as the glass, so they cross in the middle and divide the window into 4 panes. The vertical one is 5 mm thinner so the two never have faces exactly on top of each other.</p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>. In the Sidebar (<kbd>N</kbd>, Item tab) type <b>Location</b> X <code>0.84</code>, Y <code>0.05</code>, Z <code>0.67</code> (use <kbd>Tab</kbd> to jump between the fields).</li><li><b>Dimensions</b> X <code>0.1</code>, Y <code>0.66</code>, Z <code>0.04</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li>Wrench tab &rarr; Add Modifier &rarr; Generate &rarr; <b>Bevel</b>: Amount <code>0.01</code>, Segments <code>3</code>. Right-click &rarr; <b>Shade Auto Smooth</b>.</li><li>Press <kbd>F2</kbd>, type the name <code>Window_Sill</code> and press <kbd>Enter</kbd>.</li></ol><p>The sill sits under the bottom bar and sticks out further from the wall (up to X 0.89) and wider on both sides.</p><img class="slika-koraka" src="img/projekti/cute_9.jpg" alt="Step 9: Side window" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">10</div><div class="korak-vsebina"><h3>Round attic window</h3>
<ol>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Torus</b> (a ring). In Adjust Last Operation set <b>Major Radius</b> <code>0.17</code> (the size of the ring), <b>Minor Radius</b> <code>0.025</code> (the thickness of the ring), <b>Location</b> <code>0</code>, <code>-0.61</code>, <code>1.83</code> and <b>Rotation X</b> <code>90</code> so the ring stands up and faces the front.</li>
<li>Right-click &rarr; Shade Smooth. Name it <code>Attic_Ring</code>.</li>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Circle</b>. In Adjust Last Operation: <b>Radius</b> <code>0.15</code>, <b>Fill Type</b> <b>N-Gon</b> (this fills the circle so it becomes a disk), <b>Location</b> <code>0</code>, <code>-0.6</code>, <code>1.83</code>, <b>Rotation X</b> <code>90</code>. Name it <code>Attic_Glass</code>.</li>
</ol><p><b>Why these numbers?</b> the front of the gable is at Y &minus;0.59. The glass at &minus;0.6 is 1 cm in front of it, and the ring at &minus;0.61 is in front of the glass. Z 1.83 is in the middle of the triangle.</p><img class="slika-koraka" src="img/projekti/cute_10.jpg" alt="Step 10: Round attic window" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">11</div><div class="korak-vsebina"><h3>Two low-poly trees</h3>
<ol>
<li>Trunk: <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cylinder</b>. Adjust Last Operation: <b>Vertices</b> <code>8</code> (an 8-sided trunk looks low-poly), <b>Radius</b> <code>0.09</code>, <b>Depth</b> <code>0.5</code>, <b>Location</b> <code>-1.25</code>, <code>-0.45</code>, <code>0.4</code>. It goes from 0.15 to 0.65.</li>
<li>Big crown: <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Ico Sphere</b>. <b>Subdivisions</b> <code>1</code> (few, big triangles), <b>Radius</b> <code>0.35</code>, <b>Location</b> <code>-1.25</code>, <code>-0.45</code>, <code>0.88</code>.</li>
<li>Small crown: Ico Sphere, <b>Subdivisions</b> <code>1</code>, <b>Radius</b> <code>0.22</code>, <b>Location</b> <code>-1.16</code>, <code>-0.41</code>, <code>1.16</code>. It sits on top of the big crown, a little off-center.</li>
<li>Do <b>not</b> use Shade Smooth on the trees. The flat triangles are what makes the low-poly style.</li>
</ol>
<p><b>Second tree</b></p>
<ol>
<li>Click the trunk, <kbd>Shift</kbd>+click both crowns.</li>
<li><kbd>Shift</kbd>+<kbd>D</kbd> <kbd>X</kbd> <kbd>2.45</kbd> <kbd>Enter</kbd> moves the copy to the right side of the house.</li>
<li><kbd>G</kbd> <kbd>Y</kbd> <kbd>1.5</kbd> <kbd>Enter</kbd> moves it to the back.</li>
<li><kbd>S</kbd> <kbd>0.86</kbd> <kbd>Enter</kbd> makes it a bit smaller, and <kbd>R</kbd> <kbd>Z</kbd> <kbd>45</kbd> <kbd>Enter</kbd> turns it. A smaller, turned copy looks natural, an exact copy looks fake.</li>
<li>The smaller tree now floats a little. Look from the front (<kbd>Numpad 1</kbd>) and press <kbd>G</kbd> <kbd>Z</kbd>, then move it down until the trunk touches the grass, and click.</li>
</ol><img class="slika-koraka" src="img/projekti/cute_11.jpg" alt="Step 11: Two low-poly trees" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">12</div><div class="korak-vsebina"><h3>Colors (materials)</h3>
<p><b>Make the first material</b></p>
<ol>
<li>Click the <b>Grass</b> platform. In Properties click the red sphere tab (<b>Material</b>) and click <b>New</b>.</li>
<li>Double-click the name "Material" at the top and type <code>Grass</code>.</li>
<li>Click the white <b>Base Color</b> bar. In the color picker click <b>Hex</b> and paste <code>A9D57A</code>, press <kbd>Enter</kbd>.</li>
<li>Set <b>Roughness</b> to <code>0.8</code> (not shiny).</li>
<li>Press <kbd>Z</kbd> &rarr; <b>Material Preview</b> to see the color.</li>
</ol>
<p><b>Make all 12 materials the same way:</b></p>
<table class="tabela"><tr><th>Material</th><th>Hex</th><th>Roughness</th><th>Give it to</th></tr>
<tr><td>Grass</td><td><code>A9D57A</code></td><td>0.8</td><td>Grass</td></tr>
<tr><td>Wall</td><td><code>FCEBC0</code></td><td>0.8</td><td>Walls, Gable</td></tr>
<tr><td>Trim</td><td><code>FBF5EA</code></td><td>0.8</td><td>Chimney, Chimney_Cap, Smoke, Steps, window frame bars, Window_Sill, Attic_Ring</td></tr>
<tr><td>Blue</td><td><code>B9D3CF</code></td><td>0.8</td><td>Plinth, Door_Frame, Chimney_Bands</td></tr>
<tr><td>Roof</td><td><code>A8603A</code></td><td>0.8</td><td>Roof_Left, Roof_Right</td></tr>
<tr><td>Shingle</td><td><code>8F4E2E</code></td><td>0.8</td><td>Shingles (both), Ridge</td></tr>
<tr><td>Door</td><td><code>D99A4E</code></td><td>0.7</td><td>Door, Mailbox</td></tr>
<tr><td>Glass</td><td><code>CFE6EF</code></td><td>0.25</td><td>Window_Glass, Door_Window, Attic_Glass</td></tr>
<tr><td>Gold</td><td><code>E8C04A</code></td><td>0.4, Metallic 0.3</td><td>door knob</td></tr>
<tr><td>Stone</td><td><code>ECE7DE</code></td><td>0.8</td><td>the three stones</td></tr>
<tr><td>Leaves</td><td><code>8FCF6A</code></td><td>0.85</td><td>all four crowns</td></tr>
<tr><td>Trunk</td><td><code>8A5A36</code></td><td>0.9</td><td>both trunks</td></tr>
</table>
<p><b>Reusing a material</b> (for example Trim on 10 parts): make it once on one part. Then click all the other parts that need it, and <b>last</b> <kbd>Shift</kbd>+click the part that already has it, so it is the active one. Press <kbd>Ctrl</kbd>+<kbd>L</kbd> &rarr; <b>Link Materials</b>. All selected parts get the same material. You can also pick an existing material from the sphere dropdown left of the <b>New</b> button.</p><img class="slika-koraka" src="img/projekti/cute_12.jpg" alt="Step 12: Colors (materials)" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">13</div><div class="korak-vsebina"><h3>Sun, sky, camera and render</h3>
<ol>
<li><b>Sun:</b> <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Light &rarr; <b>Sun</b>. In the Sidebar set <b>Rotation</b> X <code>48</code>, Y <code>0</code>, Z <code>30</code>, so the light comes from the front-right. In the green light-bulb tab of Properties set <b>Strength</b> <code>3.2</code> and pick a very light warm yellow color.</li>
<li><b>Sky:</b> in Properties click the red globe tab (<b>World</b>), set <b>Color</b> to hex <code>CEE5F9</code>. The light-blue sky also softly brightens the shadows.</li>
<li><b>Camera:</b> <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Camera</b>. Orbit the view to look at the cottage from the front-right and a little from above, like in the picture. Then press <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd>: the camera jumps to your view. In the green camera tab set <b>Focal Length</b> to <code>45</code> mm.</li>
<li><b>Render:</b> in the Render tab choose <b>Cycles</b> and set Max Samples to <code>128</code> (or keep <b>EEVEE</b> for a result in seconds). Press <kbd>F12</kbd>.</li>
<li>In the render window choose <b>Image &rarr; Save As</b> and save it as a PNG. Also save your .blend file with <kbd>Ctrl</kbd>+<kbd>S</kbd>.</li>
</ol><img class="slika-koraka" src="img/projekti/cute_13.jpg" alt="Step 13: Sun, sky, camera and render" loading="lazy"></div></div>
<h3>If something looks wrong</h3>
<table class="tabela"><tr><th>Problem</th><th>Fix</th></tr>
<tr><td>A part is in the wrong place</td><td>Select it and check Location and Dimensions in the Sidebar against the table. A missing minus sign is the most common mistake.</td></tr>
<tr><td>The bevel looks stretched or uneven</td><td>You forgot <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale. Do it now; the bevel fixes itself.</td></tr>
<tr><td>Array strips go the wrong way</td><td>Change the sign of Distance X (0.27 &harr; &minus;0.27).</td></tr>
<tr><td>Black flickering spots</td><td>Two faces lie exactly on top of each other (z-fighting). Move or shrink one part by a few millimeters.</td></tr>
<tr><td>Everything is pink in Material Preview</td><td>Nothing is wrong with your model; a texture image is missing. This cottage uses colors only, so check that you did not add an Image Texture by mistake.</td></tr>
</table>
<h3>Bonus challenge</h3>
<p>Add a fence with the Array modifier, flowers from tiny ico spheres, or a night version: set the World color to dark blue and give the Glass material an Emission Color of warm yellow with Strength 3, so the windows glow.</p>
<p>When you are happy, mark this lesson as complete and upload your cottage to the <a href="galerija.php">gallery</a>!</p>', 'img/projekti/cute_13.jpg', 2),

(6, 'Project 3: Snowman', '<p><b>What you build:</b> a snowman with a carrot nose, coal eyes and buttons and a top hat, in a snowy scene. <b>You practice:</b> UV spheres, duplicating, typed positions in the Adjust panel, materials, the Sun light and the camera. <b>Time:</b> about 25 minutes. This one is the easiest, a good first project.</p>
<p class="nasvet">Orange = the new parts in that step. Finished file to compare: <a href="files/snowman_finished.blend" download>snowman_finished.blend</a> (made in Blender 5.0).</p>
<div class="korak-projekta"><div class="korak-st">1</div><div class="korak-vsebina"><h3>The bottom snowball</h3>
<ol><li>New file, delete the cube (<kbd>X</kbd>).</li>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>UV Sphere</b>. In Adjust Last Operation set <b>Radius 1 m</b> and <b>Location Z 1 m</b>.</li>
<li>Right click &rarr; <b>Shade Smooth</b>.</li></ol><img class="slika-koraka" src="img/projekti/snowman_1.jpg" alt="Step 1: The bottom snowball" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">2</div><div class="korak-vsebina"><h3>Middle ball and head</h3>
<ol><li>With the ball selected press <kbd>Shift</kbd>+<kbd>D</kbd>, then <kbd>Z</kbd> <kbd>1</kbd><kbd>.</kbd><kbd>4</kbd> <kbd>Enter</kbd>. The copy moves 1.4 m up.</li>
<li><kbd>S</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>7</kbd><kbd>2</kbd> <kbd>Enter</kbd> makes it smaller.</li>
<li>Duplicate the middle ball: <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>Z</kbd> <kbd>1</kbd> <kbd>Enter</kbd>, then <kbd>S</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>7</kbd> <kbd>Enter</kbd>. That is the head.</li>
<li>Look from the front (<kbd>Numpad 1</kbd>): the balls should overlap a little.</li></ol><img class="slika-koraka" src="img/projekti/snowman_2.jpg" alt="Step 2: Middle ball and head" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">3</div><div class="korak-vsebina"><h3>Nose, eyes and buttons</h3>
<ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cone</b>. In Adjust Last Operation: <b>Radius 1 = 0.08</b>, <b>Radius 2 = 0</b>, <b>Depth 0.4</b>, <b>Location Y -0.5, Z 3.4</b>, <b>Rotation X 90&deg;</b>. The carrot now points forward.</li>
<li>Eye: <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; UV Sphere with <b>Radius 0.05</b>, <b>Location X -0.17, Y -0.44, Z 3.55</b>. Duplicate it with <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>X</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>3</kbd><kbd>4</kbd> <kbd>Enter</kbd> for the second eye.</li>
<li>Buttons: a UV Sphere with Radius 0.06 at <b>Y -0.67, Z 2.65</b>, then duplicate it down twice with <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>Z</kbd> <kbd>-</kbd><kbd>0</kbd><kbd>.</kbd><kbd>3</kbd> <kbd>Enter</kbd>. Move each one with <kbd>G</kbd> <kbd>Y</kbd> until it just touches the body (check in the side view <kbd>Numpad 3</kbd>).</li>
<li>Select all the small parts and right click &rarr; Shade Smooth.</li></ol><img class="slika-koraka" src="img/projekti/snowman_3.jpg" alt="Step 3: Nose, eyes and buttons" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">4</div><div class="korak-vsebina"><h3>Top hat</h3>
<ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cylinder</b>: Radius 0.55, Depth 0.05, Location Z 3.78. That is the brim.</li>
<li>Another Cylinder: Radius 0.35, Depth 0.55, Location Z 4.05. That is the top.</li></ol><img class="slika-koraka" src="img/projekti/snowman_4.jpg" alt="Step 4: Top hat" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">5</div><div class="korak-vsebina"><h3>Materials</h3>
<ol><li>Select a snowball &rarr; Material tab &rarr; New &rarr; <code>Snow</code>: almost white (not pure white), Roughness 0.5. Give the other two balls the same material from the dropdown.</li>
<li><code>Coal</code>: near black, Roughness 0.4, for eyes, buttons and both hat parts.</li>
<li><code>Carrot</code>: orange, Roughness 0.45, for the nose.</li>
<li>Tip: select all objects that need the same material, then select the one that already has it last (it becomes active) and press <kbd>Ctrl</kbd>+<kbd>L</kbd> &rarr; <b>Link Materials</b>.</li></ol><img class="slika-koraka" src="img/projekti/snowman_5.jpg" alt="Step 5: Materials" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">6</div><div class="korak-vsebina"><h3>Snowy scene and render</h3>
<ol><li>Plane for the ground: <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Plane, <kbd>S</kbd> <kbd>4</kbd><kbd>0</kbd>, with the Snow material.</li>
<li>Replace the light with a <b>Sun</b>, Strength 3, slightly warm color. World color: light grey-blue for a winter sky.</li>
<li>Camera: <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd> from a nice view, Focal Length 40 mm.</li>
<li><kbd>F12</kbd> and Image &rarr; Save As.</li></ol><img class="slika-koraka" src="img/projekti/snowman_6.jpg" alt="Step 6: Snowy scene and render" loading="lazy"></div></div>
<h3>Bonus challenge</h3>
<p>Add stick arms from thin cylinders, a scarf from a torus (scale it flat with <kbd>S</kbd> <kbd>Z</kbd>), or sculpt the snowballs to look less perfect with the Sculpt Mode Grab brush.</p>', 'img/projekti/snowman_6.jpg', 3),

(7, 'Chapter 1: Setup and the Dress', '<p class="nasvet"><b>Time:</b> about 60 minutes &nbsp;·&nbsp; <b>You learn:</b> setting up a project, the Adjust Last Operation panel, loop cuts, selecting edge loops, shaping a mesh by scaling rings.<br>This is chapter 1 of 6 of one long course (about <b>6 hours</b> in total). Do one or two chapters per day, there is no rush. In the pictures the parts you add in that step are <b>orange</b>.</p>
<p><b>What you build in the whole course:</b> a low-poly girl in a pink polka-dot sweater dress with boots, hair with a fringe, and a T-pose (arms straight out, the standard pose for characters that will be animated later). "Low-poly" means she is made of few, big flat faces, which looks cute and stylized and is much easier to model than a realistic person.</p>
<img class="slika-koraka" src="img/projekti/char_22.jpg" alt="The finished low-poly character" loading="lazy">
<p class="nasvet">Finished file to compare at any time: <a href="files/lowpoly_character_finished.blend" download>lowpoly_character_finished.blend</a> (made in Blender 5.0). All sizes in this course are copied from the original model, so your character will match it.</p>
<div class="korak-projekta"><div class="korak-st">1</div><div class="korak-vsebina"><h3>Set up the project</h3>
<ol>
<li>Open Blender and choose <b>File &rarr; New &rarr; General</b>.</li>
<li>Press <kbd>A</kbd> to select everything and <kbd>X</kbd> &rarr; <b>Delete</b>. The default cube, camera and light are gone; we add our own at the end.</li>
<li>Save right away: <b>File &rarr; Save As</b>, name it <code>lowpoly_girl.blend</code>. From now on press <kbd>Ctrl</kbd>+<kbd>S</kbd> after every step.</li>
</ol>
<p><b>We build her 10&times; bigger than the original</b> (about 11.7 m tall). Size does not matter for the look, and this way you type easy numbers like <code>0.85</code> instead of <code>0.085</code>. You can scale the whole character down at the end if you ever need to.</p>
<h3>The two places where you type numbers</h3>
<ul>
<li><b>Adjust Last Operation panel:</b> right after you add an object, a small panel appears in the bottom-left corner of the viewport. If it is folded, click its title. Here you set things that only exist while creating: <b>Vertices</b>, <b>Radius</b>, <b>Depth</b>, <b>Segments</b>&hellip; and also Location and Rotation. If you click anything else first, the panel disappears; then just delete the object and add it again.</li>
<li><b>Sidebar:</b> press <kbd>N</kbd> in the viewport, <b>Item</b> tab. Here you can change Location, Rotation, Scale and Dimensions of the selected object at any time.</li>
</ul>
<h3>How to read the numbers</h3>
<p><b>Location</b> is the <b>center</b> of a part. <b>Radius</b> is half the width of a round part, <b>Depth</b> is its length. X goes from her right (&minus;, the left side of your screen in front view) to her left (+), Y from front (&minus;) to back (+), Z from the floor up. So a cylinder with Location Z <code>3</code> and Depth <code>2.4</code> goes from 3 &minus; 1.2 = <b>1.8</b> to 3 + 1.2 = <b>4.2</b>. The "Why these numbers?" notes in every step use this, so you understand how the parts fit together.</p>
<h3>Navigation you will need a lot</h3>
<ul>
<li><kbd>Numpad 1</kbd> front view, <kbd>Numpad 3</kbd> side view, <kbd>Numpad 7</kbd> top view.</li>
<li><kbd>Numpad .</kbd> zooms to the selected object, <kbd>Home</kbd> shows everything.</li>
<li><kbd>Alt</kbd>+<kbd>Z</kbd> X-ray: see and select through the model.</li>
</ul></div></div><div class="korak-projekta"><div class="korak-st">2</div><div class="korak-vsebina"><h3>The dress: a cylinder with loop cuts</h3><p>The sweater dress is the biggest part. We start with a simple 10-sided cylinder and then shape it.</p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>Cylinder</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Vertices</b> <code>10</code>, <b>Radius</b> <code>1</code>, <b>Depth</b> <code>4.3</code>, <b>Location Z</b> <code>5.85</code>.</li><li><kbd>F2</kbd>, type <code>Dress</code>, <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> Depth 4.3 with center 5.85 means the dress goes from 5.85 &minus; 2.15 = <b>3.7</b> (the hem, where the legs come out) to <b>8.0</b> (the shoulders). Only <b>10 vertices</b> around keeps it low-poly: you will clearly see 10 flat sides.</p>
<p><b>Add three loop cuts</b> so we have rings we can make wider or narrower:</p>
<ol>
<li>Press <kbd>Tab</kbd> for Edit Mode.</li>
<li>Press <kbd>Ctrl</kbd>+<kbd>R</kbd> and move the mouse over one of the long <b>vertical</b> edges. A yellow ring appears around the cylinder.</li>
<li><b>Scroll the mouse wheel up</b> twice, so you see <b>3</b> yellow rings.</li>
<li><b>Left-click</b> once, then <b>right-click</b>. The three rings are placed at equal distances.</li>
</ol>
<p>The dress now has 5 rings: at Z 3.7, 4.775, 5.85, 6.925 and 8.0. Stay in Edit Mode for the next step.</p><img class="slika-koraka" src="img/projekti/char_2.jpg" alt="Step 2: The dress: a cylinder with loop cuts" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">3</div><div class="korak-vsebina"><h3>Shape the dress like a bell</h3>
<p>Now we scale each ring to a different size. Work from the bottom up. Look from the front (<kbd>Numpad 1</kbd>) and orbit a little so you can see the rings.</p>
<table class="tabela"><tr><th>Ring</th><th>How to select it</th><th>Type</th></tr>
<tr><td>1 (bottom, Z 3.7)</td><td><kbd>3</kbd> face select, orbit to see the underside, click the <b>bottom face</b></td><td><kbd>S</kbd> <kbd>1.66</kbd> <kbd>Enter</kbd></td></tr>
<tr><td>2 (Z 4.775)</td><td><kbd>2</kbd> edge select, <kbd>Alt</kbd>+click a <b>horizontal</b> edge of this ring</td><td><kbd>S</kbd> <kbd>1.83</kbd> <kbd>Enter</kbd></td></tr>
<tr><td>3 (Z 5.85)</td><td><kbd>Alt</kbd>+click a horizontal edge of the middle ring</td><td><kbd>S</kbd> <kbd>1.6</kbd> <kbd>Enter</kbd></td></tr>
<tr><td>4 (Z 6.925)</td><td><kbd>Alt</kbd>+click a horizontal edge</td><td><kbd>S</kbd> <kbd>1.25</kbd> <kbd>Enter</kbd></td></tr>
<tr><td>5 (top, Z 8.0)</td><td><kbd>3</kbd> face select, click the <b>top face</b></td><td><kbd>S</kbd> <kbd>0.93</kbd> <kbd>Enter</kbd></td></tr>
</table>
<ol>
<li>Last, press <kbd>A</kbd> to select everything and type <kbd>S</kbd> <kbd>Y</kbd> <kbd>0.92</kbd> <kbd>Enter</kbd>. The dress becomes a little flatter from front to back, like a real body.</li>
<li>Press <kbd>Tab</kbd> to go back to Object Mode. Do <b>not</b> use Shade Smooth: the flat faces are the low-poly style.</li>
</ol>
<p><b>What does <kbd>S</kbd> do here?</b> Scaling a ring moves all its vertices away from the center (number bigger than 1) or toward it (smaller than 1). Ring 2 at 1.83 is the widest part, so the dress flares out above the hem and the bottom ring at 1.66 tucks in a little, which makes the round "bell" shape. The top ring at 0.93 makes narrow shoulders.</p>
<p><b>Alt+click selected the wrong thing?</b> If you click a vertical edge, Blender selects a vertical line instead of a ring. Press <kbd>Alt</kbd>+<kbd>A</kbd> to deselect and click again, exactly on a horizontal edge.</p><p><b>Check:</b> in front view (<kbd>Numpad 1</kbd>) the dress looks like a pear or bell: widest near the bottom, narrow at the top.</p><img class="slika-koraka" src="img/projekti/char_3.jpg" alt="Step 3: Shape the dress like a bell" loading="lazy"></div></div>', 'img/projekti/char_3.jpg', 1),

(7, 'Chapter 2: Collar, Neck and Head', '<p class="nasvet"><b>Time:</b> about 30 minutes &nbsp;·&nbsp; <b>You learn:</b> the Torus, building on top of other parts, UV spheres with few segments.<br>Chapter 2 of 6. In the pictures the parts you add in that step are <b>orange</b>.</p><div class="korak-projekta"><div class="korak-st">4</div><div class="korak-vsebina"><h3>The turtleneck collar</h3><p>A torus is a ring (a donut). <b>Major Radius</b> is the size of the ring, <b>Minor Radius</b> is how thick the tube is. <b>Major Segments</b> and <b>Minor Segments</b> are how many sides it has around and across.</p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>Torus</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Major Segments</b> <code>10</code>, <b>Minor Segments</b> <code>6</code>, <b>Major Radius</b> <code>0.85</code>, <b>Minor Radius</b> <code>0.4</code>, <b>Location Z</b> <code>8.3</code>.</li><li><kbd>F2</kbd>, type <code>Collar</code>, <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> the tube is 0.4 thick, so the collar goes from 8.3 &minus; 0.4 = 7.9 to 8.7. Its outer edge (0.85 + 0.4 = 1.25) is wider than the top of the dress (0.93), so it sits over the shoulders like a thick turtleneck and hides the joint. The hole in the middle has radius 0.85 &minus; 0.4 = 0.45, just right for the neck.</p><img class="slika-koraka" src="img/projekti/char_4.jpg" alt="Step 4: The turtleneck collar" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">5</div><div class="korak-vsebina"><h3>Neck and head</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>Cylinder</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Vertices</b> <code>10</code>, <b>Radius</b> <code>0.3</code>, <b>Depth</b> <code>0.8</code>, <b>Location Z</b> <code>8.5</code>.</li><li><kbd>F2</kbd>, type <code>Neck</code>, <kbd>Enter</kbd>.</li></ol><p>The head is a UV sphere with very few segments, which gives the faceted low-poly face.</p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>UV Sphere</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Segments</b> <code>8</code>, <b>Ring Count</b> <code>6</code>, <b>Radius</b> <code>0.85</code>, <b>Location Z</b> <code>9.75</code>.</li><li><kbd>F2</kbd>, type <code>Head</code>, <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> the neck goes from 8.1 to 8.9; its lower part is hidden inside the collar. The head goes from 9.75 &minus; 0.85 = <b>8.9</b> to 10.6, so it sits exactly on top of the neck. A normal UV sphere has 32 segments; with only 8 segments and 6 rings you clearly see the flat faces.</p><p><b>Check:</b> press <kbd>Numpad 3</kbd> for the side view. The neck should be fully hidden in the collar at the bottom and in the head at the top.</p><img class="slika-koraka" src="img/projekti/char_5.jpg" alt="Step 5: Neck and head" loading="lazy"></div></div>', 'img/projekti/char_5.jpg', 2),

(7, 'Chapter 3: Legs and Boots', '<p class="nasvet"><b>Time:</b> about 60 minutes &nbsp;·&nbsp; <b>You learn:</b> building one side only, stacking parts, the Bevel modifier with 1 segment, mirroring objects with the 3D cursor.<br>Chapter 3 of 6. We build only her right leg (the left side of your screen), then mirror it. In the pictures the parts you add in that step are <b>orange</b>.</p><div class="korak-projekta"><div class="korak-st">6</div><div class="korak-vsebina"><h3>The leg</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>Cylinder</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Vertices</b> <code>10</code>, <b>Radius</b> <code>0.35</code>, <b>Depth</b> <code>2.4</code>, <b>Location</b> <code>-0.75, 0, 3</code>.</li><li><kbd>F2</kbd>, type <code>Leg_R</code>, <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> X &minus;0.75 moves the leg to the side, so later there is a gap of 0.8 between the two legs. It goes from 3 &minus; 1.2 = 1.8 to 4.2. The top 0.5 is hidden inside the dress (the hem is at 3.7), so there is never a gap between leg and dress. The bottom will be covered by the boot.</p><img class="slika-koraka" src="img/projekti/char_6.jpg" alt="Step 6: The leg" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">7</div><div class="korak-vsebina"><h3>The boot</h3><p><b>7a. The boot shaft</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>Cylinder</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Vertices</b> <code>12</code>, <b>Radius</b> <code>0.52</code>, <b>Depth</b> <code>1.5</code>, <b>Location</b> <code>-0.75, 0, 1.05</code>.</li><li><kbd>F2</kbd>, type <code>Boot_R</code>, <kbd>Enter</kbd>.</li></ol><p><b>7b. The foot</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>.</li><li>Sidebar (<kbd>N</kbd>, Item tab): <b>Location</b> X <code>-0.75</code>, Y <code>-0.2</code>, Z <code>0.325</code>.</li><li><b>Dimensions</b> X <code>1.0</code>, Y <code>1.6</code>, Z <code>0.65</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li><kbd>F2</kbd>, type <code>Foot_R</code>, <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> the shaft goes from 0.3 to 1.8 and is wider (0.52) than the leg (0.35), so it looks like a boot around the leg. The foot box goes from Z 0 (the floor) to 0.65 and from Y &minus;1.0 to 0.6. The shaft front is at Y &minus;0.52, so the foot sticks out <b>0.48 in front</b>: that is the toe. Y &minus;0.2 shifts the box forward for exactly this reason.</p><img class="slika-koraka" src="img/projekti/char_7.jpg" alt="Step 7: The boot" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">8</div><div class="korak-vsebina"><h3>The fluffy cuff</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>Cylinder</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Vertices</b> <code>8</code>, <b>Radius</b> <code>0.62</code>, <b>Depth</b> <code>0.9</code>, <b>Location</b> <code>-0.75, 0, 2.2</code>.</li><li>Properties &rarr; <b>Modifiers</b> (wrench) &rarr; <b>Add Modifier</b> &rarr; <b>Generate</b> &rarr; <b>Bevel</b>. Set <b>Amount</b> <code>0.15</code> and <b>Segments</b> <code>1</code>.</li><li><kbd>F2</kbd>, type <code>Cuff_R</code>, <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> the cuff goes from 1.75 to 2.65, covering the top of the boot (1.8) and the leg. Its radius 0.62 is bigger than the boot (0.52), so it sticks out all around like a thick knitted sock. The Bevel with <b>1 segment</b> cuts every corner off at an angle instead of rounding it, which fits the low-poly look.</p><img class="slika-koraka" src="img/projekti/char_8.jpg" alt="Step 8: The fluffy cuff" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">9</div><div class="korak-vsebina"><h3>Mirror the leg</h3><p>Parts: <b>Leg_R, Boot_R, Foot_R, Cuff_R</b>.</p>
<p><b>Mirror the leg to the other side</b></p>
<ol>
<li>Select all the parts listed above: click the first one, then <kbd>Shift</kbd>+click the others (or <kbd>Ctrl</kbd>+click their names in the Outliner).</li>
<li>Make sure the <b>3D cursor</b> is in the middle of the world: <kbd>Shift</kbd>+<kbd>S</kbd> &rarr; <b>Cursor to World Origin</b>.</li>
<li>In the viewport header, open the <b>Transform Pivot Point</b> dropdown (the icon with two linked circles, next to the Global dropdown) and choose <b>3D Cursor</b>.</li>
<li><kbd>Shift</kbd>+<kbd>D</kbd> to duplicate, then <b>right-click</b> so the copies stay where they are.</li>
<li>Menu <b>Object &rarr; Mirror &rarr; X Global</b> (or press <kbd>Ctrl</kbd>+<kbd>M</kbd>, then <kbd>X</kbd>, <kbd>Enter</kbd>). The copies flip over the middle line of the body and land on the other side.</li>
<li>Set the Pivot Point back to <b>Median Point</b>, otherwise rotating and scaling will feel strange later.</li>
</ol>
<p><b>Why the 3D cursor?</b> Mirroring flips objects around the pivot point. With the pivot on the 3D cursor at X 0 (the center line of the character), the left side flips exactly onto the right side. In the Sidebar the copies show Scale X <code>-1</code>: that is normal for mirrored objects, do not change it.</p><p>Rename the copies with <kbd>F2</kbd> to Leg_L, Boot_L, Foot_L and Cuff_L.</p><p><b>Check:</b> front view (<kbd>Numpad 1</kbd>): both legs stand at the same height with the same gap to the middle.</p><img class="slika-koraka" src="img/projekti/char_9.jpg" alt="Step 9: Mirror the leg" loading="lazy"></div></div>', 'img/projekti/char_9.jpg', 3),

(7, 'Chapter 4: Arms and Hands', '<p class="nasvet"><b>Time:</b> about 60 minutes &nbsp;·&nbsp; <b>You learn:</b> rotated cylinders, tapering by scaling a face, Dimensions on spheres, mirroring a group of parts.<br>Chapter 4 of 6. Again we build only her right arm and mirror it. In the pictures the parts you add in that step are <b>orange</b>.</p><div class="korak-projekta"><div class="korak-st">10</div><div class="korak-vsebina"><h3>The sleeve</h3><p>A cylinder normally stands up. Rotation Y 90 lays it down so it points sideways, like an arm in a T-pose.</p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>Cylinder</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Vertices</b> <code>6</code>, <b>Radius</b> <code>0.66</code>, <b>Depth</b> <code>2.7</code>, <b>Location</b> <code>-2.05, 0, 7.4</code>, <b>Rotation Y</b> <code>90</code>.</li><li><kbd>F2</kbd>, type <code>Sleeve_R</code>, <kbd>Enter</kbd>.</li></ol>
<p><b>Make it narrower toward the hand:</b></p>
<ol>
<li><kbd>Tab</kbd>, then <kbd>3</kbd> for face select.</li>
<li>Click the end face that is far from the body (the hand end, on the left of your screen in front view).</li>
<li><kbd>S</kbd> <kbd>0.75</kbd> <kbd>Enter</kbd>. That end now has radius 0.5 instead of 0.66.</li>
<li><kbd>Tab</kbd> back to Object Mode.</li>
</ol><p><b>Why these numbers?</b> the sleeve goes from X &minus;2.05 &minus; 1.35 = <b>&minus;3.4</b> to &minus;0.7. The inner end is hidden in the dress, so the arm grows out of the shoulder without a gap. Z 7.4 is just under the collar. 6 sides is enough for a stylized arm.</p><img class="slika-koraka" src="img/projekti/char_10.jpg" alt="Step 10: The sleeve" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">11</div><div class="korak-vsebina"><h3>Sleeve cuff and wrist</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>Cylinder</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Vertices</b> <code>8</code>, <b>Radius</b> <code>0.58</code>, <b>Depth</b> <code>0.64</code>, <b>Location</b> <code>-3.62, 0, 7.4</code>, <b>Rotation Y</b> <code>90</code>.</li><li><kbd>F2</kbd>, type <code>SleeveCuff_R</code>, <kbd>Enter</kbd>.</li></ol><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>Cylinder</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Vertices</b> <code>6</code>, <b>Radius</b> <code>0.24</code>, <b>Depth</b> <code>0.4</code>, <b>Location</b> <code>-4.05, 0, 7.37</code>, <b>Rotation Y</b> <code>90</code>.</li><li><kbd>F2</kbd>, type <code>Wrist_R</code>, <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> the cuff goes from X &minus;3.94 to &minus;3.3, so it overlaps the end of the sleeve (&minus;3.4) and covers the joint. It is wider (0.58) than the sleeve end (0.5), so it looks like a turned-up cuff. The thin wrist goes from &minus;4.25 to &minus;3.85 and comes out of the cuff.</p><img class="slika-koraka" src="img/projekti/char_11.jpg" alt="Step 11: Sleeve cuff and wrist" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">12</div><div class="korak-vsebina"><h3>Mitten hand and thumb</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>UV Sphere</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Segments</b> <code>6</code>, <b>Ring Count</b> <code>4</code>, <b>Location</b> <code>-4.6, 0, 7.34</code>.</li><li>In the Sidebar set <b>Dimensions</b> X <code>1.24</code>, Y <code>0.7</code>, Z <code>0.44</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale. The ball becomes a long, flat mitten.</li><li><kbd>F2</kbd>, type <code>Hand_R</code>, <kbd>Enter</kbd>.</li></ol><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>UV Sphere</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Segments</b> <code>6</code>, <b>Ring Count</b> <code>4</code>, <b>Location</b> <code>-4.3, -0.36, 7.38</code>, <b>Rotation Z</b> <code>-34</code>.</li><li><b>Dimensions</b> X <code>0.41</code>, Y <code>0.21</code>, Z <code>0.26</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale.</li><li><kbd>F2</kbd>, type <code>Thumb_R</code>, <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> the hand goes from X &minus;5.22 to &minus;3.98 and starts inside the wrist. Y &minus;0.36 puts the thumb on the front side of the hand, and Rotation Z &minus;34 angles it toward the front, like a real thumb.</p><img class="slika-koraka" src="img/projekti/char_12.jpg" alt="Step 12: Mitten hand and thumb" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">13</div><div class="korak-vsebina"><h3>Mirror the arm</h3><p>Parts: <b>Sleeve_R, SleeveCuff_R, Wrist_R, Hand_R, Thumb_R</b>.</p>
<p><b>Mirror the arm to the other side</b></p>
<ol>
<li>Select all the parts listed above: click the first one, then <kbd>Shift</kbd>+click the others (or <kbd>Ctrl</kbd>+click their names in the Outliner).</li>
<li>Make sure the <b>3D cursor</b> is in the middle of the world: <kbd>Shift</kbd>+<kbd>S</kbd> &rarr; <b>Cursor to World Origin</b>.</li>
<li>In the viewport header, open the <b>Transform Pivot Point</b> dropdown (the icon with two linked circles, next to the Global dropdown) and choose <b>3D Cursor</b>.</li>
<li><kbd>Shift</kbd>+<kbd>D</kbd> to duplicate, then <b>right-click</b> so the copies stay where they are.</li>
<li>Menu <b>Object &rarr; Mirror &rarr; X Global</b> (or press <kbd>Ctrl</kbd>+<kbd>M</kbd>, then <kbd>X</kbd>, <kbd>Enter</kbd>). The copies flip over the middle line of the body and land on the other side.</li>
<li>Set the Pivot Point back to <b>Median Point</b>, otherwise rotating and scaling will feel strange later.</li>
</ol>
<p><b>Why the 3D cursor?</b> Mirroring flips objects around the pivot point. With the pivot on the 3D cursor at X 0 (the center line of the character), the left side flips exactly onto the right side. In the Sidebar the copies show Scale X <code>-1</code>: that is normal for mirrored objects, do not change it.</p><p><b>Check:</b> front view: she now stands in a symmetric T-pose. Save with <kbd>Ctrl</kbd>+<kbd>S</kbd>, you are halfway!</p><img class="slika-koraka" src="img/projekti/char_13.jpg" alt="Step 13: Mirror the arm" loading="lazy"></div></div>', 'img/projekti/char_13.jpg', 4),

(7, 'Chapter 5: Face and Hair', '<p class="nasvet"><b>Time:</b> about 90 minutes &nbsp;·&nbsp; <b>You learn:</b> deleting half of a mesh, X-ray selection, the Solidify modifier, making spikes from a cube, placing many parts from a table.<br>Chapter 5 of 6, the longest one. Zoom in on the head with <kbd>Numpad .</kbd> and take your time. In the pictures the parts you add in that step are <b>orange</b>.</p><div class="korak-projekta"><div class="korak-st">14</div><div class="korak-vsebina"><h3>Eyes</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>UV Sphere</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Segments</b> <code>8</code>, <b>Ring Count</b> <code>6</code>, <b>Location</b> <code>-0.34, -0.68, 9.9</code>, <b>Rotation X</b> <code>-13</code>, <b>Rotation Z</b> <code>-24</code>.</li><li><b>Dimensions</b> X <code>0.23</code>, Y <code>0.12</code>, Z <code>0.38</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale. The eye becomes a tall, flat oval.</li><li><kbd>F2</kbd>, type <code>Eye_R</code>, <kbd>Enter</kbd>.</li></ol><p><b>Why these numbers?</b> the front of the head is at about Y &minus;0.75 at this height, so an eye centered at &minus;0.68 and 0.12 thick pokes out just a little. Rotation Z &minus;24 turns it to follow the round head, and X &minus;13 tilts it back slightly, so it lies flat on the face.</p>
<p><b>Mirror the eye to the other side</b></p>
<ol>
<li>Select all the parts listed above: click the first one, then <kbd>Shift</kbd>+click the others (or <kbd>Ctrl</kbd>+click their names in the Outliner).</li>
<li>Make sure the <b>3D cursor</b> is in the middle of the world: <kbd>Shift</kbd>+<kbd>S</kbd> &rarr; <b>Cursor to World Origin</b>.</li>
<li>In the viewport header, open the <b>Transform Pivot Point</b> dropdown (the icon with two linked circles, next to the Global dropdown) and choose <b>3D Cursor</b>.</li>
<li><kbd>Shift</kbd>+<kbd>D</kbd> to duplicate, then <b>right-click</b> so the copies stay where they are.</li>
<li>Menu <b>Object &rarr; Mirror &rarr; X Global</b> (or press <kbd>Ctrl</kbd>+<kbd>M</kbd>, then <kbd>X</kbd>, <kbd>Enter</kbd>). The copies flip over the middle line of the body and land on the other side.</li>
<li>Set the Pivot Point back to <b>Median Point</b>, otherwise rotating and scaling will feel strange later.</li>
</ol>
<p><b>Why the 3D cursor?</b> Mirroring flips objects around the pivot point. With the pivot on the 3D cursor at X 0 (the center line of the character), the left side flips exactly onto the right side. In the Sidebar the copies show Scale X <code>-1</code>: that is normal for mirrored objects, do not change it.</p><img class="slika-koraka" src="img/projekti/char_14.jpg" alt="Step 14: Eyes" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">15</div><div class="korak-vsebina"><h3>Hair cap (half a sphere)</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>UV Sphere</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Segments</b> <code>8</code>, <b>Ring Count</b> <code>6</code>, <b>Radius</b> <code>1.22</code>, <b>Location</b> <code>0, 0.05, 10.15</code>.</li><li><kbd>F2</kbd>, type <code>Hair_Cap</code>, <kbd>Enter</kbd>.</li></ol>
<p><b>Delete the lower half:</b></p>
<ol>
<li><kbd>Tab</kbd> for Edit Mode, <kbd>1</kbd> for vertex select, <kbd>Numpad 1</kbd> for the front view.</li>
<li>Press <kbd>Alt</kbd>+<kbd>Z</kbd> to turn on X-ray. Without it, box select only grabs the vertices you can see, not the ones at the back.</li>
<li><kbd>Alt</kbd>+<kbd>A</kbd> to deselect. Press <kbd>B</kbd> and drag a rectangle around <b>all vertices below the widest row</b> (the middle row stays unselected).</li>
<li><kbd>X</kbd> &rarr; <b>Vertices</b>. Only the upper half remains, like a cap.</li>
<li><kbd>Alt</kbd>+<kbd>Z</kbd> to turn X-ray off, <kbd>Tab</kbd> back to Object Mode.</li>
<li>Type <kbd>S</kbd> <kbd>Z</kbd> <kbd>1.28</kbd> <kbd>Enter</kbd> to make the cap taller, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale.</li>
</ol><p><b>Why these numbers?</b> the widest row of the sphere is at its center, Z 10.15, so the edge of the cap goes around her forehead. Radius 1.22 is bigger than the head (0.85), so there is room for "volume" in the hair. After scaling Z by 1.28 the top is at 10.15 + 1.22 &times; 1.28 = <b>11.71</b>.</p><img class="slika-koraka" src="img/projekti/char_15.jpg" alt="Step 15: Hair cap (half a sphere)" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">16</div><div class="korak-vsebina"><h3>Back hair with the Solidify modifier</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Mesh</b> &rarr; <b>Cylinder</b>.</li><li>Open the <b>Adjust Last Operation</b> panel (bottom-left corner of the viewport) and set: <b>Vertices</b> <code>10</code>, <b>Radius</b> <code>1.2</code>, <b>Depth</b> <code>1.8</code>, <b>Location</b> <code>0, 0.2, 9.55</code>.</li><li><kbd>S</kbd> <kbd>Y</kbd> <kbd>0.85</kbd> <kbd>Enter</kbd>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale.</li><li><kbd>F2</kbd>, type <code>Hair_Back</code>, <kbd>Enter</kbd>.</li></ol>
<p><b>Open the front so the face is free:</b></p>
<ol>
<li><kbd>Tab</kbd>, <kbd>1</kbd> vertex select, <kbd>Numpad 7</kbd> top view, <kbd>Alt</kbd>+<kbd>Z</kbd> X-ray on.</li>
<li><kbd>Alt</kbd>+<kbd>A</kbd>, then <kbd>B</kbd> and drag a box around the <b>3 vertices closest to the bottom of the screen</b> (the front). Because of X-ray you select the top and the bottom vertex of each, 6 in total.</li>
<li><kbd>X</kbd> &rarr; <b>Vertices</b>. The front sides and the top and bottom caps disappear. What is left is a curved wall around the back of the head.</li>
<li><kbd>Alt</kbd>+<kbd>Z</kbd> off, <kbd>Tab</kbd> back.</li>
</ol>
<p><b>Give it thickness:</b> Modifiers &rarr; Add Modifier &rarr; Generate &rarr; <b>Solidify</b>, <b>Thickness</b> <code>0.25</code>. A surface with no thickness looks like paper and can disappear from some angles; Solidify turns it into a real, thick layer of hair.</p><p><b>Why these numbers?</b> the back hair goes from 8.65 (down to the collar) to 10.45 (up under the cap). Y 0.2 moves it backward, because hair hangs mostly behind the head. In the picture you see her from behind.</p><img class="slika-koraka" src="img/projekti/char_16.jpg" alt="Step 16: Back hair with the Solidify modifier" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">17</div><div class="korak-vsebina"><h3>The fringe: five hair spikes</h3>
<p><b>Make one spike from a cube:</b></p><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>.</li><li>Sidebar (<kbd>N</kbd>, Item tab): <b>Location</b> X <code>0</code>, Y <code>-1.0</code>, Z <code>10.44</code>.</li><li><b>Rotation</b> X <code>-18</code>.</li><li><b>Dimensions</b> X <code>0.58</code>, Y <code>0.22</code>, Z <code>0.56</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li><kbd>Tab</kbd>, <kbd>3</kbd> face select. Orbit so you can see under the box and click the <b>bottom face</b>.</li><li><kbd>S</kbd> <kbd>0.25</kbd> <kbd>Enter</kbd>. The bottom shrinks to a quarter and the box becomes a wedge that points down, like a lock of hair. <kbd>Tab</kbd> back.</li><li><kbd>F2</kbd>, type <code>Fringe_1</code>, <kbd>Enter</kbd>.</li></ol>
<p><b>Four more:</b> with the spike selected press <kbd>Shift</kbd>+<kbd>D</kbd>, right-click, then type the values of the next row into the Sidebar. Repeat for every row:</p>
<table class="tabela"><tr><th>Spike</th><th>Location X, Y, Z</th><th>Rotation X, Y, Z</th></tr>
<tr><td>Fringe_2</td><td><code>-0.6, -0.81, 10.47</code></td><td><code>-16, -19, -32</code></td></tr>
<tr><td>Fringe_3</td><td><code>-0.32, -0.95, 10.4</code></td><td><code>-18, -10, -16</code></td></tr>
<tr><td>Fringe_1 (done)</td><td><code>0, -1.0, 10.44</code></td><td><code>-18, 0, 0</code></td></tr>
<tr><td>Fringe_4</td><td><code>0.31, -0.95, 10.38</code></td><td><code>-18, 9, 15</code></td></tr>
<tr><td>Fringe_5</td><td><code>0.59, -0.82, 10.47</code></td><td><code>-16, 19, 31</code></td></tr>
</table><p><b>Why these numbers?</b> the spikes follow the curve of the forehead: the middle one is furthest forward (Y &minus;1.0), the outer ones are further back and turned outward (Rotation Z &plusmn;32). The small differences in height (10.38 to 10.47) make the fringe look natural instead of a perfect row. Because we duplicate an already finished spike, every copy has the same wedge shape.</p><img class="slika-koraka" src="img/projekti/char_17.jpg" alt="Step 17: The fringe: five hair spikes" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">18</div><div class="korak-vsebina"><h3>Long side locks</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>.</li><li>Sidebar (<kbd>N</kbd>, Item tab): <b>Location</b> X <code>-0.95</code>, Y <code>-0.58</code>, Z <code>9.4</code>.</li><li><b>Rotation</b> X <code>2</code>, Y <code>9</code>, Z <code>-54</code>.</li><li><b>Dimensions</b> X <code>0.5</code>, Y <code>0.34</code>, Z <code>2.0</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li><kbd>Tab</kbd>, <kbd>3</kbd>, click the <b>bottom face</b>, <kbd>S</kbd> <kbd>0.4</kbd> <kbd>Enter</kbd>, <kbd>Tab</kbd>.</li><li><kbd>F2</kbd>, type <code>Lock_R</code>, <kbd>Enter</kbd>.</li></ol>
<p><b>Mirror the lock to the other side</b></p>
<ol>
<li>Select all the parts listed above: click the first one, then <kbd>Shift</kbd>+click the others (or <kbd>Ctrl</kbd>+click their names in the Outliner).</li>
<li>Make sure the <b>3D cursor</b> is in the middle of the world: <kbd>Shift</kbd>+<kbd>S</kbd> &rarr; <b>Cursor to World Origin</b>.</li>
<li>In the viewport header, open the <b>Transform Pivot Point</b> dropdown (the icon with two linked circles, next to the Global dropdown) and choose <b>3D Cursor</b>.</li>
<li><kbd>Shift</kbd>+<kbd>D</kbd> to duplicate, then <b>right-click</b> so the copies stay where they are.</li>
<li>Menu <b>Object &rarr; Mirror &rarr; X Global</b> (or press <kbd>Ctrl</kbd>+<kbd>M</kbd>, then <kbd>X</kbd>, <kbd>Enter</kbd>). The copies flip over the middle line of the body and land on the other side.</li>
<li>Set the Pivot Point back to <b>Median Point</b>, otherwise rotating and scaling will feel strange later.</li>
</ol>
<p><b>Why the 3D cursor?</b> Mirroring flips objects around the pivot point. With the pivot on the 3D cursor at X 0 (the center line of the character), the left side flips exactly onto the right side. In the Sidebar the copies show Scale X <code>-1</code>: that is normal for mirrored objects, do not change it.</p><p><b>Why these numbers?</b> this is the same wedge as the fringe, but 2 m long, so it hangs down beside the face from the cap (10.4) to the collar (8.4). Rotation Z &minus;54 turns its wide side to face diagonally forward, so it frames the face.</p><img class="slika-koraka" src="img/projekti/char_18.jpg" alt="Step 18: Long side locks" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">19</div><div class="korak-vsebina"><h3>Hair tips at the back</h3><ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>.</li><li>Sidebar (<kbd>N</kbd>, Item tab): <b>Location</b> X <code>-0.43</code>, Y <code>1.01</code>, Z <code>8.6</code>.</li><li><b>Rotation</b> Z <code>-157</code>.</li><li><b>Dimensions</b> X <code>0.76</code>, Y <code>0.3</code>, Z <code>0.7</code>, then <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>.</li><li><kbd>Tab</kbd>, <kbd>3</kbd>, bottom face, <kbd>S</kbd> <kbd>0.25</kbd> <kbd>Enter</kbd>, <kbd>Tab</kbd>.</li><li><kbd>F2</kbd>, type <code>Tip_R1</code>, <kbd>Enter</kbd>.</li></ol>
<p>Duplicate it twice (<kbd>Shift</kbd>+<kbd>D</kbd>, right-click) and type:</p>
<table class="tabela"><tr><th>Tip</th><th>Location X, Y, Z</th><th>Rotation Z</th></tr>
<tr><td>Tip_R2</td><td><code>-0.79, 0.77, 8.53</code></td><td><code>-134</code></td></tr>
<tr><td>Tip_R3</td><td><code>-1.03, 0.4, 8.55</code></td><td><code>-111</code></td></tr>
</table>
<p><b>Mirror the three tips to the other side</b></p>
<ol>
<li>Select all the parts listed above: click the first one, then <kbd>Shift</kbd>+click the others (or <kbd>Ctrl</kbd>+click their names in the Outliner).</li>
<li>Make sure the <b>3D cursor</b> is in the middle of the world: <kbd>Shift</kbd>+<kbd>S</kbd> &rarr; <b>Cursor to World Origin</b>.</li>
<li>In the viewport header, open the <b>Transform Pivot Point</b> dropdown (the icon with two linked circles, next to the Global dropdown) and choose <b>3D Cursor</b>.</li>
<li><kbd>Shift</kbd>+<kbd>D</kbd> to duplicate, then <b>right-click</b> so the copies stay where they are.</li>
<li>Menu <b>Object &rarr; Mirror &rarr; X Global</b> (or press <kbd>Ctrl</kbd>+<kbd>M</kbd>, then <kbd>X</kbd>, <kbd>Enter</kbd>). The copies flip over the middle line of the body and land on the other side.</li>
<li>Set the Pivot Point back to <b>Median Point</b>, otherwise rotating and scaling will feel strange later.</li>
</ol>
<p><b>Why the 3D cursor?</b> Mirroring flips objects around the pivot point. With the pivot on the 3D cursor at X 0 (the center line of the character), the left side flips exactly onto the right side. In the Sidebar the copies show Scale X <code>-1</code>: that is normal for mirrored objects, do not change it.</p><p><b>Why these numbers?</b> the tips hang at the lower edge of the back hair (8.65) and follow its curve around the back. Each is turned (Rotation Z) so its wide side faces outward, away from the center of the head. Together they make the jagged, cut-hair edge you see in the picture from behind.</p><img class="slika-koraka" src="img/projekti/char_19.jpg" alt="Step 19: Hair tips at the back" loading="lazy"></div></div>', 'img/projekti/char_18.jpg', 5),

(7, 'Chapter 6: Colors, Spots and Render', '<p class="nasvet"><b>Time:</b> about 60 minutes &nbsp;·&nbsp; <b>You learn:</b> materials with hex colors, Link Materials, snapping objects onto a surface, lighting and rendering a character.<br>Chapter 6 of 6, the last one! In the pictures the parts you add in that step are <b>orange</b>.</p><div class="korak-projekta"><div class="korak-st">20</div><div class="korak-vsebina"><h3>Colors</h3>
<p><b>Make the first material:</b> click the Dress &rarr; Properties &rarr; red sphere tab (<b>Material</b>) &rarr; <b>New</b>. Double-click the name and type <code>Sweater</code>. Click the <b>Base Color</b> bar, choose <b>Hex</b>, paste <code>E47C9F</code>, <kbd>Enter</kbd>. Set <b>Roughness</b> <code>0.85</code> (soft, like wool).</p>
<p>Make the others the same way:</p>
<table class="tabela"><tr><th>Material</th><th>Hex</th><th>Roughness</th><th>Give it to</th></tr>
<tr><td>Sweater</td><td><code>E47C9F</code></td><td>0.85</td><td>Dress, Collar, Sleeves, both Cuffs on the legs</td></tr>
<tr><td>Skin</td><td><code>E2BEA4</code></td><td>0.85</td><td>Head, Neck, Wrists, Hands, Thumbs</td></tr>
<tr><td>Hair</td><td><code>8A3F27</code></td><td>0.7</td><td>Hair_Cap, Hair_Back, all fringe, locks and tips</td></tr>
<tr><td>Boots</td><td><code>3A3449</code></td><td>0.85</td><td>Boots, Feet, both Sleeve cuffs</td></tr>
<tr><td>Leggings</td><td><code>1D1D2E</code></td><td>0.85</td><td>both Legs</td></tr>
<tr><td>Eyes</td><td><code>121216</code></td><td>0.35 (a bit shiny)</td><td>both Eyes</td></tr>
</table>
<p><b>Fast way for many parts:</b> select all parts that need the same material, then <kbd>Shift</kbd>+click a part that already has it <b>last</b> (it becomes the active one, lighter outline) and press <kbd>Ctrl</kbd>+<kbd>L</kbd> &rarr; <b>Link Materials</b>. Perfect for the 13 hair parts. Mirrored copies need their material too.</p>
<p>Press <kbd>Z</kbd> &rarr; <b>Material Preview</b> to see the colors.</p><img class="slika-koraka" src="img/projekti/char_20.jpg" alt="Step 20: Colors" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">21</div><div class="korak-vsebina"><h3>Polka spots with surface snapping</h3>
<p>The dress and sleeves have about 34 small hexagon spots in yellow and rose. Placing them by typing numbers would take forever, so we let Blender <b>stick them onto the surface</b>.</p>
<p><b>21a. Make one spot</b></p>
<ol>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Circle</b>. Adjust Last Operation: <b>Vertices</b> <code>6</code> (a hexagon), <b>Radius</b> <code>0.25</code>, <b>Fill Type</b> <b>N-Gon</b> (so it is a filled shape, not just a line).</li>
<li>Give it a new material <code>Spot_Yellow</code>, hex <code>F6CF4F</code>, Roughness 0.85.</li>
</ol>
<p><b>21b. Turn on snapping to faces</b></p>
<ol>
<li>In the viewport header click the <b>magnet</b> icon (or <kbd>Shift</kbd>+<kbd>Tab</kbd>). It turns blue.</li>
<li>Click the small arrow next to the magnet. Under <b>Snap To</b> choose <b>Face Project</b>. Tick <b>Align Rotation to Target</b>.</li>
</ol>
<p>Now when you move an object with <kbd>G</kbd>, it jumps onto the surface under your mouse, and <b>Align Rotation</b> turns it so it lies flat on that surface.</p>
<p><b>21c. Place the spots</b></p>
<ol>
<li>Select the spot, press <kbd>G</kbd> and move the mouse over the front of the dress. The spot sticks to it. Click to place it.</li>
<li><kbd>Shift</kbd>+<kbd>D</kbd>: the copy also sticks to the surface while you move it. Click to drop it somewhere else. Repeat until the dress has about 24 spots all around (orbit to do the sides and back) and each sleeve about 5.</li>
<li>For variety, scale some spots a little (<kbd>S</kbd> <kbd>0.8</kbd> or <kbd>S</kbd> <kbd>1.3</kbd>).</li>
<li>Make a second material <code>Spot_Rose</code>, hex <code>C25782</code>, and give it to about one third of the spots.</li>
<li>Turn the magnet <b>off</b> again when you are done, otherwise it will surprise you later.</li>
</ol><p><b>Check:</b> orbit around her: no spot should float in the air or be hidden inside the dress. If one does, select it and move it again with <kbd>G</kbd> while snapping is on.</p><img class="slika-koraka" src="img/projekti/char_21.jpg" alt="Step 21: Polka spots with surface snapping" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">22</div><div class="korak-vsebina"><h3>Light, camera and render</h3>
<ol>
<li><b>Floor (optional):</b> <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; Cylinder with <b>Vertices</b> <code>48</code>, <b>Radius</b> <code>7</code>, <b>Depth</b> <code>0.3</code>, <b>Location Z</b> <code>-0.15</code>. A round stage looks great for showing a character. Give it a light grey-blue material.</li>
<li><b>Sun:</b> <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Light &rarr; <b>Sun</b>, Strength <code>3</code>, Rotation X <code>50</code>, Y <code>0</code>, Z <code>25</code>.</li>
<li><b>Soft fill light:</b> <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Light &rarr; <b>Area</b>, Power <code>1500</code> W, Size <code>10</code> m, placed at the front-left at Location <code>-10, -8, 10</code>. Rotate it so it points at her (the light''s line should aim at her chest). It brightens the shadows on the face.</li>
<li><b>World:</b> World tab &rarr; Color hex <code>DCE6F0</code>.</li>
<li><b>Camera:</b> <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Camera. Navigate to a view from the front, a little to the right and slightly above her chest, then <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd>. Focal Length <code>50</code> mm. In the camera view (<kbd>Numpad 0</kbd>) she should fill most of the frame.</li>
<li><b>Render:</b> Render tab &rarr; Cycles, Max Samples <code>128</code> (or EEVEE for a quick result). <kbd>F12</kbd>, then <b>Image &rarr; Save As</b>. Save the .blend with <kbd>Ctrl</kbd>+<kbd>S</kbd>.</li>
</ol><img class="slika-koraka" src="img/projekti/char_22.jpg" alt="Step 22: Light, camera and render" loading="lazy"></div></div>
<h3>If something looks wrong</h3>
<table class="tabela"><tr><th>Problem</th><th>Fix</th></tr>
<tr><td>A part is in the wrong place</td><td>Select it and compare Location, Rotation and Dimensions in the Sidebar with the step. A missing minus sign is the most common mistake.</td></tr>
<tr><td>The Adjust Last Operation panel is gone</td><td>It disappears after any other action. Delete the object and add it again.</td></tr>
<tr><td>Mirrored parts landed in a strange place</td><td>The pivot was not set to 3D Cursor, or the cursor was not at the world origin. Undo (<kbd>Ctrl</kbd>+<kbd>Z</kbd>) and repeat the mirror steps.</td></tr>
<tr><td>Box select missed vertices at the back</td><td>X-ray (<kbd>Alt</kbd>+<kbd>Z</kbd>) was off. Undo, turn X-ray on and select again.</td></tr>
<tr><td>Everything moves in jumps</td><td>Snapping (magnet) is still on. Click the magnet to turn it off.</td></tr>
</table>
<h3>Where to go next</h3>
<p>Your character is in a T-pose, ready to be <b>rigged</b> (given a skeleton) and animated. A good next step is to add an <b>Armature</b> with Shift+A and learn about bones, or to make her a friend: a pet, a second character, or a little house from the Guided Projects.</p>
<p>Mark this chapter as complete and upload your render to the <a href="galerija.php">gallery</a>!</p>', 'img/projekti/char_22.jpg', 6);

INSERT INTO bliznjica (tipka, opis, kategorija) VALUES
('Tab', 'Switch between Object Mode and Edit Mode', 'General'),
('F3', 'Search for any command', 'General'),
('Ctrl + Z', 'Undo', 'General'),
('Ctrl + Shift + Z', 'Redo', 'General'),
('Ctrl + S', 'Save the .blend file', 'General'),
('N', 'Toggle the Sidebar (exact location, rotation, scale)', 'General'),
('T', 'Toggle the Toolbar', 'General'),
('Ctrl + Space', 'Maximize the editor under the mouse', 'General'),
('Shift + A', 'Add a new object', 'General'),
('X', 'Delete menu', 'General'),
('Numpad 1 / 3 / 7', 'Front / Right / Top view', 'Navigation'),
('Numpad 5', 'Perspective / Orthographic', 'Navigation'),
('Numpad 0', 'Camera view', 'Navigation'),
('Ctrl + Alt + Numpad 0', 'Move the camera to the current view', 'Navigation'),
('Numpad .', 'Zoom to the selection', 'Navigation'),
('Home', 'Show all objects', 'Navigation'),
('~', 'View pie menu (no numpad needed)', 'Navigation'),
('Z', 'Viewport shading pie (Solid, Material Preview, Rendered)', 'Navigation'),
('Alt + Z', 'Toggle X-ray', 'Navigation'),
('G', 'Move (grab)', 'Transform'),
('R', 'Rotate', 'Transform'),
('S', 'Scale', 'Transform'),
('X / Y / Z', 'Lock the transform to an axis', 'Transform'),
('Shift + D', 'Duplicate', 'Transform'),
('Alt + G / R / S', 'Reset location / rotation / scale', 'Transform'),
('Ctrl + A', 'Apply scale / rotation', 'Transform'),
('Shift + S', 'Snap menu (cursor to selected, to world origin)', 'Transform'),
('1 / 2 / 3', 'Vertex / edge / face select (Edit Mode)', 'Modeling'),
('E', 'Extrude', 'Modeling'),
('I', 'Inset (press twice for individual faces)', 'Modeling'),
('Ctrl + R', 'Loop cut (scroll for more cuts)', 'Modeling'),
('Ctrl + B', 'Bevel edges (scroll for segments)', 'Modeling'),
('K', 'Knife', 'Modeling'),
('M', 'Merge vertices (By Distance removes doubles)', 'Modeling'),
('F', 'Fill: make an edge or face', 'Modeling'),
('Alt + Click', 'Select an edge loop', 'Modeling'),
('L', 'Select linked under the mouse', 'Modeling'),
('O', 'Proportional editing on/off', 'Modeling'),
('Ctrl + 1 / 2 / 3', 'Add Subdivision Surface level 1-3', 'Modeling'),
('Ctrl + J', 'Join objects', 'Modeling'),
('U', 'UV unwrap menu', 'Texturing'),
('Ctrl + E', 'Edge menu (Mark Seam)', 'Texturing'),
('F', 'Brush radius (paint and sculpt)', 'Texturing'),
('Shift + F', 'Brush strength (paint and sculpt)', 'Texturing'),
('S', 'Sample a color (Texture Paint)', 'Texturing'),
('Shift + Alt + S', 'Save the painted image as (Image Editor)', 'Texturing'),
('Ctrl', 'Hold to invert the brush (Sculpt)', 'Sculpting'),
('Shift', 'Hold to smooth (Sculpt)', 'Sculpting'),
('R / Ctrl + R', 'Set voxel size / Remesh (Sculpt)', 'Sculpting'),
('Alt + M', 'Clear the mask (Sculpt)', 'Sculpting'),
('Ctrl + L', 'Link materials to selected objects', 'Shading'),
('F12', 'Render an image', 'Shading'),
('Ctrl + F12', 'Render an animation', 'Shading'),
('F11', 'Show the last render', 'Shading');
