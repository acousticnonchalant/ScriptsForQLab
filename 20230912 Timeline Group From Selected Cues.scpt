FasdUAS 1.101.10   ��   ��    k             l      ��  ��   �� 

9/12/2023
Tested with QLab v5.2.3 on macOS Ventura 13.5.2

Timeline Group from Selected Cues
This script will make a timeline group out of selected cues and copy the name, number and color from the first cue in the list.
You should put this script into a script cue and trigger it with a hotkey from a Stream Deck, or give it a unique number and trigger it from Companion.

Written by Chase Elison 
chase@chaseelison.com

     � 	 	R   
 
 9 / 1 2 / 2 0 2 3 
 T e s t e d   w i t h   Q L a b   v 5 . 2 . 3   o n   m a c O S   V e n t u r a   1 3 . 5 . 2 
 
 T i m e l i n e   G r o u p   f r o m   S e l e c t e d   C u e s 
 T h i s   s c r i p t   w i l l   m a k e   a   t i m e l i n e   g r o u p   o u t   o f   s e l e c t e d   c u e s   a n d   c o p y   t h e   n a m e ,   n u m b e r   a n d   c o l o r   f r o m   t h e   f i r s t   c u e   i n   t h e   l i s t . 
 Y o u   s h o u l d   p u t   t h i s   s c r i p t   i n t o   a   s c r i p t   c u e   a n d   t r i g g e r   i t   w i t h   a   h o t k e y   f r o m   a   S t r e a m   D e c k ,   o r   g i v e   i t   a   u n i q u e   n u m b e r   a n d   t r i g g e r   i t   f r o m   C o m p a n i o n . 
 
 W r i t t e n   b y   C h a s e   E l i s o n   
 c h a s e @ c h a s e e l i s o n . c o m 
 
   
  
 l     ��������  ��  ��        l         r         m     ��
�� boovfals  o      ���� 40 copyfirstcuenotestogroup copyFirstCueNotesToGroup  O I Whether or not to copy the cue notes from the first cue to the group cue     �   �   W h e t h e r   o r   n o t   t o   c o p y   t h e   c u e   n o t e s   f r o m   t h e   f i r s t   c u e   t o   t h e   g r o u p   c u e      l        r        m    ��
�� boovfals  o      ���� 20 copycontinuemodetogroup copyContinueModeToGroup  E ? Whether or not to use the same continue mode the first cue had     �   ~   W h e t h e r   o r   n o t   t o   u s e   t h e   s a m e   c o n t i n u e   m o d e   t h e   f i r s t   c u e   h a d      l     ��������  ��  ��        l   �  ����   O   � ! " ! O    � # $ # k    � % %  & ' & Z   % ( )���� ( =    * + * 1    ��
�� 
qIEM + m    ��
�� boovfals ) L    !����  ��  ��   '  , - , r   & + . / . 1   & )��
�� 
qSEL / o      ���� 0 theselection theSelection -  0 1 0 l  , ,�� 2 3��   2 ; 5if (count of theSelection) is less than 2 then return    3 � 4 4 j i f   ( c o u n t   o f   t h e S e l e c t i o n )   i s   l e s s   t h a n   2   t h e n   r e t u r n 1  5 6 5 r   , 2 7 8 7 n   , 0 9 : 9 4   - 0�� ;
�� 
cobj ; m   . /����  : o   , -���� 0 theselection theSelection 8 o      ���� 0 firstcue firstCue 6  < = < I  3 :���� >
�� .QLabmakenull���     qDoc��   > �� ?��
�� 
newT ? m   5 6 @ @ � A A 
 G r o u p��   =  B C B r   ; E D E D n   ; C F G F 4  @ C�� H
�� 
cobj H m   A B������ G l  ; @ I���� I c   ; @ J K J 1   ; >��
�� 
qSEL K m   > ?��
�� 
list��  ��   E o      ���� 0 groupcue groupCue C  L M L r   F O N O N m   F I��
�� GRUPqGFT O n       P Q P 1   J N��
�� 
qGMo Q o   I J���� 0 groupcue groupCue M  R S R Z   P k T U�� V T o   P Q���� 20 copycontinuemodetogroup copyContinueModeToGroup U r   T _ W X W n   T Y Y Z Y 1   U Y��
�� 
qCon Z o   T U���� 0 firstcue firstCue X n       [ \ [ 1   Z ^��
�� 
qCon \ o   Y Z���� 0 groupcue groupCue��   V r   b k ] ^ ] m   b e��
�� ContNoCo ^ n       _ ` _ 1   f j��
�� 
qCon ` o   e f���� 0 groupcue groupCue S  a b a r   l w c d c n   l q e f e 1   m q��
�� 
qDNm f o   l m���� 0 firstcue firstCue d n       g h g 1   r v��
�� 
qNam h o   q r���� 0 groupcue groupCue b  i j i Z   x � k l���� k o   x y���� 40 copyfirstcuenotestogroup copyFirstCueNotesToGroup l r   | � m n m n   | � o p o 1   } ���
�� 
qNot p o   | }���� 0 firstcue firstCue n n       q r q 1   � ���
�� 
qNot r o   � ����� 0 groupcue groupCue��  ��   j  s t s r   � � u v u n   � � w x w 1   � ���
�� 
pnam x o   � ����� 0 firstcue firstCue v o      ���� 0 	newnumber 	newNumber t  y z y r   � � { | { m   � � } } � ~ ~   | n        �  1   � ���
�� 
pnam � o   � ����� 0 firstcue firstCue z  � � � r   � � � � � o   � ����� 0 	newnumber 	newNumber � n       � � � 1   � ���
�� 
pnam � o   � ����� 0 groupcue groupCue �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
qCol � o   � ����� 0 firstcue firstCue � n       � � � 1   � ���
�� 
qCol � o   � ����� 0 groupcue groupCue �  ��� � X   � � ��� � � I  � ��� � �
�� .coremovenull���     obj  � n   � � � � � 5   � ��� ���
�� 
aCue � l  � � ����� � n   � � � � � 1   � ���
�� 
ID   � o   � ����� 0 eachcue eachCue��  ��  
�� kfrmID   � l  � � ����� � n   � � � � � 1   � ���
�� 
qPar � o   � ����� 0 eachcue eachCue��  ��   � �� ���
�� 
insh � n   � � � � �  ;   � � � o   � ����� 0 groupcue groupCue��  �� 0 eachcue eachCue � o   � ����� 0 theselection theSelection��   $ 4   �� �
�� 
qDoc � m    ����  " 5    �� ���
�� 
capp � m   
  � � � � � & c o m . f i g u r e 5 3 . Q L a b . 5
�� kfrmID  ��  ��     � � � l     ��������  ��  ��   �  ��� � l      �� � ���   � � �

Changes-
9/12/23 - Added option to copy notes from the first cue to the group cue
9/12/23 - Added option to copy the continue mode from the first cue to the group cue

    � � � �T 
 
 C h a n g e s - 
 9 / 1 2 / 2 3   -   A d d e d   o p t i o n   t o   c o p y   n o t e s   f r o m   t h e   f i r s t   c u e   t o   t h e   g r o u p   c u e 
 9 / 1 2 / 2 3   -   A d d e d   o p t i o n   t o   c o p y   t h e   c o n t i n u e   m o d e   f r o m   t h e   f i r s t   c u e   t o   t h e   g r o u p   c u e 
 
��       �� � ���   � ��
�� .aevtoappnull  �   � **** � �� ����� � ���
�� .aevtoappnull  �   � **** � k     � � �   � �   � �  ����  ��  ��   � ���� 0 eachcue eachCue � "������ ����������������� @����������������������� }�~�}�|�{�z�y�x�w�� 40 copyfirstcuenotestogroup copyFirstCueNotesToGroup�� 20 copycontinuemodetogroup copyContinueModeToGroup
�� 
capp
�� kfrmID  
�� 
qDoc
�� 
qIEM
�� 
qSEL�� 0 theselection theSelection
�� 
cobj�� 0 firstcue firstCue
�� 
newT
�� .QLabmakenull���     qDoc
�� 
list�� 0 groupcue groupCue
�� GRUPqGFT
�� 
qGMo
�� 
qCon
�� ContNoCo
�� 
qDNm
�� 
qNam
�� 
qNot
�� 
pnam� 0 	newnumber 	newNumber
�~ 
qCol
�} 
kocl
�| .corecnte****       ****
�{ 
qPar
�z 
aCue
�y 
ID  
�x 
insh
�w .coremovenull���     obj �� �fE�OfE�O)���0 �*�k/ �*�,f  hY hO*�,E�O��k/E�O*��l O*�,�&�i/E�Oa �a ,FO� �a ,�a ,FY a �a ,FO�a ,�a ,FO� �a ,�a ,FY hO�a ,E` Oa �a ,FO_ �a ,FO�a ,�a ,FO /�[a �l kh  �a ,a �a ,E�0a  �6l ![OY��UUascr  ��ޭ