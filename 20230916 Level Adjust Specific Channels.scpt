FasdUAS 1.101.10   ��   ��    k             l      ��  ��   YS 

9/16/2023
Tested with QLab v5.2.3 on macOS Ventura 13.5.2

Active Cue Level Adjust, Based on Cue's Output Routing
This script will change volume on all CURRENTLY PLAYING tracks if they are routed to the outputs defined below. Will only work in edit mode.
See below for user variables, such as whether or not you want to set an absolute level or a relative level, and what the level will be,
You should put this script into a script cue and trigger it with a hotkey from a Stream Deck, or give it a unique number and trigger it from Companion.

Written by Chase Elison 
chase@chaseelison.com

     � 	 	�   
 
 9 / 1 6 / 2 0 2 3 
 T e s t e d   w i t h   Q L a b   v 5 . 2 . 3   o n   m a c O S   V e n t u r a   1 3 . 5 . 2 
 
 A c t i v e   C u e   L e v e l   A d j u s t ,   B a s e d   o n   C u e ' s   O u t p u t   R o u t i n g 
 T h i s   s c r i p t   w i l l   c h a n g e   v o l u m e   o n   a l l   C U R R E N T L Y   P L A Y I N G   t r a c k s   i f   t h e y   a r e   r o u t e d   t o   t h e   o u t p u t s   d e f i n e d   b e l o w .   W i l l   o n l y   w o r k   i n   e d i t   m o d e . 
 S e e   b e l o w   f o r   u s e r   v a r i a b l e s ,   s u c h   a s   w h e t h e r   o r   n o t   y o u   w a n t   t o   s e t   a n   a b s o l u t e   l e v e l   o r   a   r e l a t i v e   l e v e l ,   a n d   w h a t   t h e   l e v e l   w i l l   b e , 
 Y o u   s h o u l d   p u t   t h i s   s c r i p t   i n t o   a   s c r i p t   c u e   a n d   t r i g g e r   i t   w i t h   a   h o t k e y   f r o m   a   S t r e a m   D e c k ,   o r   g i v e   i t   a   u n i q u e   n u m b e r   a n d   t r i g g e r   i t   f r o m   C o m p a n i o n . 
 
 W r i t t e n   b y   C h a s e   E l i s o n   
 c h a s e @ c h a s e e l i s o n . c o m 
 
   
  
 l     ��������  ��  ��        l     ����  r         m     ��
�� boovfals  o      ���� (0 onlyworkineditmode onlyWorkInEditMode��  ��        l     ��������  ��  ��        l     ��  ��    � � Change the value to true and change the absolute level if you wish to set the level to a defined level and not a relative level     �      C h a n g e   t h e   v a l u e   t o   t r u e   a n d   c h a n g e   t h e   a b s o l u t e   l e v e l   i f   y o u   w i s h   t o   s e t   t h e   l e v e l   t o   a   d e f i n e d   l e v e l   a n d   n o t   a   r e l a t i v e   l e v e l      l    ����  r        m    ��
�� boovfals  o      ���� &0 makeabsolutelevel makeAbsoluteLevel��  ��        l    ����  r       !   m    	����   ! o      ���� 0 absolutelevel absoluteLevel��  ��     " # " l     ��������  ��  ��   #  $ % $ l     �� & '��   & K E Change this level if you want to add/subtract from the current level    ' � ( ( �   C h a n g e   t h i s   l e v e l   i f   y o u   w a n t   t o   a d d / s u b t r a c t   f r o m   t h e   c u r r e n t   l e v e l %  ) * ) l    +���� + r     , - , m    ����  - o      ���� 0 relativelevel relativeLevel��  ��   *  . / . l     ��������  ��  ��   /  0 1 0 l     �� 2 3��   2 i c Change the values in the following variable to reflect the output(s) of the cue you wish to adjust    3 � 4 4 �   C h a n g e   t h e   v a l u e s   i n   t h e   f o l l o w i n g   v a r i a b l e   t o   r e f l e c t   t h e   o u t p u t ( s )   o f   t h e   c u e   y o u   w i s h   t o   a d j u s t 1  5 6 5 l    7���� 7 r     8 9 8 J     : :  ; < ; m    ����  <  =�� = m    ���� ��   9 o      ���� &0 usersearchcolumns userSearchColumns��  ��   6  > ? > l     ��������  ��  ��   ?  @ A @ l  C B���� B O  C C D C O   B E F E k   &A G G  H I H Z   & 5 J K�� L J o   & '���� (0 onlyworkineditmode onlyWorkInEditMode K r   * / M N M 1   * -��
�� 
qIEM N o      ���� 0 doscript doScript��   L r   2 5 O P O m   2 3��
�� boovtrue P o      ���� 0 doscript doScript I  Q�� Q Z   6A R S���� R =  6 9 T U T o   6 7���� 0 doscript doScript U m   7 8��
�� boovtrue S k   <= V V  W X W r   < A Y Z Y 1   < ?��
�� 
actQ Z o      ���� 0 theselection theSelection X  [ \ [ l  B B�� ] ^��   ] 9 3 theSelection is the cues that are currently active    ^ � _ _ f   t h e S e l e c t i o n   i s   t h e   c u e s   t h a t   a r e   c u r r e n t l y   a c t i v e \  `�� ` X   B= a�� b a Z   R8 c d���� c E  R c e f e J   R ] g g  h i h m   R U j j � k k 
 A u d i o i  l m l m   U X n n � o o 
 V i d e o m  p�� p m   X [ q q � r r  M i c��   f n   ] b s t s 1   ^ b��
�� 
qTyp t o   ] ^���� 0 eachcue eachCue d k   f4 u u  v w v l  f f�� x y��   x 2 , If the current cue is an audio or video cue    y � z z X   I f   t h e   c u r r e n t   c u e   i s   a n   a u d i o   o r   v i d e o   c u e w  {�� { O   f4 | } | k   m3 ~ ~   �  r   m r � � � m   m n��
�� boovfals � o      ����  0 matchesrouting matchesRouting �  � � � l  s s�� � ���   �   Default answer is false.    � � � � 2   D e f a u l t   a n s w e r   i s   f a l s e . �  � � � Y   s � ��� � ��� � k   � � � �  � � � l  � ��� � ���   � % Check each row of the audio cue    � � � � > C h e c k   e a c h   r o w   o f   t h e   a u d i o   c u e �  ��� � X   � � ��� � � k   � � � �  � � � l  � ��� � ���   � $ Check each user defined column    � � � � < C h e c k   e a c h   u s e r   d e f i n e d   c o l u m n �  � � � Z   � � � ����� � F   � � � � � F   � � � � � =  � � � � � l  � � ����� � I  � ��� � �
�� .QLablevgnull���     aCue � o   � ����� 0 eachcue eachCue � �� � �
�� 
levR � o   � ����� 0 eachrow eachRow � �� ���
�� 
levC � o   � ����� $0 eachsearchcolumn eachSearchColumn��  ��  ��   � m   � �����   � =  � � � � � n   � � � � � 1   � ���
�� 
qRun � o   � ����� 0 eachcue eachCue � m   � ���
�� boovtrue � =  � � � � � n   � � � � � 1   � ���
�� 
qPRE � o   � ����� 0 eachcue eachCue � m   � �����   � k   � � � �  � � � l  � ��� � ���   � � �If the vaule of the row and column tested is 0, and the cue is running (not paused), and the cue is not pre-waiting, then the current cue is a match.    � � � �* I f   t h e   v a u l e   o f   t h e   r o w   a n d   c o l u m n   t e s t e d   i s   0 ,   a n d   t h e   c u e   i s   r u n n i n g   ( n o t   p a u s e d ) ,   a n d   t h e   c u e   i s   n o t   p r e - w a i t i n g ,   t h e n   t h e   c u r r e n t   c u e   i s   a   m a t c h . �  ��� � r   � � � � � m   � ���
�� boovtrue � o      ����  0 matchesrouting matchesRouting��  ��  ��   �  ��� � l  � ��� � ���   � � �display dialog "GetLevel " & eachRow & " " & userSearchColumn & " " & q display name of eachCue & (eachCue getLevel row eachRow column userSearchColumn)    � � � �0 d i s p l a y   d i a l o g   " G e t L e v e l   "   &   e a c h R o w   &   "   "   &   u s e r S e a r c h C o l u m n   &   "   "   &   q   d i s p l a y   n a m e   o f   e a c h C u e   &   ( e a c h C u e   g e t L e v e l   r o w   e a c h R o w   c o l u m n   u s e r S e a r c h C o l u m n )��  �� $0 eachsearchcolumn eachSearchColumn � o   � ����� &0 usersearchcolumns userSearchColumns��  �� 0 eachrow eachRow � m   v w����  � n   w } � � � 1   x |��
�� 
qNCh � o   w x���� 0 eachcue eachCue��   �  � � � l  � ��� � ���   � W Qdisplay dialog "cue " & q display name of eachCue & " matches? " & matchesRouting    � � � � � d i s p l a y   d i a l o g   " c u e   "   &   q   d i s p l a y   n a m e   o f   e a c h C u e   &   "   m a t c h e s ?   "   &   m a t c h e s R o u t i n g �  ��� � Z   �3 � ����� � =  � � � � � o   � �����  0 matchesrouting matchesRouting � m   � ���
�� boovtrue � k   �/ � �  � � � l  � ��� � ���   � + %Cue has been determined to be a match    � � � � J C u e   h a s   b e e n   d e t e r m i n e d   t o   b e   a   m a t c h �  ��� � Z   �/ � ��� � � =  � � � � � o   � ����� &0 makeabsolutelevel makeAbsoluteLevel � m   � ���
�� boovtrue � k   � � � �  � � � l  � ��� � ���   � J DIf the user wants to set the level to an absolute level, then do so!    � � � � � I f   t h e   u s e r   w a n t s   t o   s e t   t h e   l e v e l   t o   a n   a b s o l u t e   l e v e l ,   t h e n   d o   s o ! �  ��� � I  � ��� � �
�� .QLablevsnull���     aCue � o   � ����� 0 eachcue eachCue � �� � �
�� 
levR � m   � �����   � �� � �
�� 
levC � m   � �����   � �� ���
�� 
levD � o   � ����� 0 absolutelevel absoluteLevel��  ��  ��   � k   �/ � �  � � � l  � ��� � ���   � h bIf the user does not want an absolute level, then add the definied relative level to current level    � � � � � I f   t h e   u s e r   d o e s   n o t   w a n t   a n   a b s o l u t e   l e v e l ,   t h e n   a d d   t h e   d e f i n i e d   r e l a t i v e   l e v e l   t o   c u r r e n t   l e v e l �  � � � r   � � � � I  ��� � �
�� .QLablevgnull���     aCue � o   � ��� 0 eachcue eachCue � �~ � �
�~ 
levR � m   �}�}   � �| ��{
�| 
levC � m  �z�z  �{   � o      �y�y 0 currentlevel currentLevel �  � � � r   � � � [   � � � o  �x�x 0 currentlevel currentLevel � o  �w�w 0 relativelevel relativeLevel � o      �v�v 0 newlevel newLevel �  ��u � I /�t � �
�t .QLablevsnull���     aCue � o  �s�s 0 eachcue eachCue � �r � 
�r 
levR � m  �q�q    �p
�p 
levC m  "#�o�o   �n�m
�n 
levD o  &)�l�l 0 newlevel newLevel�m  �u  ��  ��  ��  ��   } 4  f j�k
�k 
qDoc m   h i�j�j ��  ��  ��  �� 0 eachcue eachCue b o   E F�i�i 0 theselection theSelection��  ��  ��  ��   F 4   #�h
�h 
qDoc m   ! "�g�g  D 5    �f�e
�f 
capp m     � & c o m . f i g u r e 5 3 . Q L a b . 5
�e kfrmID  ��  ��   A 	
	 l     �d�c�b�d  �c  �b  
 �a l      �`�`   @ :

Changes-

9/16/2023 - No change, just verified working

    � t 
 
 C h a n g e s - 
 
 9 / 1 6 / 2 0 2 3   -   N o   c h a n g e ,   j u s t   v e r i f i e d   w o r k i n g 
 
�a       �_�_   �^
�^ .aevtoappnull  �   � **** �]�\�[�Z
�] .aevtoappnull  �   � **** k    C        )  5  @�Y�Y  �\  �[   �X�W�V�X 0 eachcue eachCue�W 0 eachrow eachRow�V $0 eachsearchcolumn eachSearchColumn "�U�T�S�R�Q�P�O�N�M�L�K�J�I�H�G j n q�F�E�D�C�B�A�@�?�>�=�<�;�:�9�8�U (0 onlyworkineditmode onlyWorkInEditMode�T &0 makeabsolutelevel makeAbsoluteLevel�S 0 absolutelevel absoluteLevel�R 0 relativelevel relativeLevel�Q &0 usersearchcolumns userSearchColumns
�P 
capp
�O kfrmID  
�N 
qDoc
�M 
qIEM�L 0 doscript doScript
�K 
actQ�J 0 theselection theSelection
�I 
kocl
�H 
cobj
�G .corecnte****       ****
�F 
qTyp�E  0 matchesrouting matchesRouting
�D 
qNCh
�C 
levR
�B 
levC�A 
�@ .QLablevgnull���     aCue
�? 
qRun
�> 
bool
�= 
qPRE
�< 
levD�; 
�: .QLablevsnull���     aCue�9 0 currentlevel currentLevel�8 0 newlevel newLevel�ZDfE�OfE�OjE�OkE�OkllvE�O)���0%*�k/� 
*�,E�Y eE�O�e *�,E�O ��[��l kh  a a a mv�a , �*�k/ �fE` O ck�a ,Ekh  O�[��l kh �a �a �a  j 	 �a ,e a &	 �a ,j a & 
eE` Y hOP[OY��[OY��O_ e  T�e  �a ja ja �a  Y 5�a ja ja  E`  O_  �E` !O�a ja ja _ !a  Y hUY h[OY�Y hUU ascr  ��ޭ