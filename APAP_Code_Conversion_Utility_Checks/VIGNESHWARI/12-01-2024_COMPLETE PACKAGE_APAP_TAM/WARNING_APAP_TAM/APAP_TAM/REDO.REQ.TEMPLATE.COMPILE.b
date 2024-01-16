* @ValidationCode : MjotMzgzNzk4ODQ0OkNwMTI1MjoxNzA0ODg4OTkwMDYxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Jan 2024 17:46:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
PROGRAM REDO.REQ.TEMPLATE.COMPILE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REQUEST.PROCESS
*--------------------------------------------------------------------------------------------------------
*Description  : This is a Auto id routine for REDO.CARD.REQUEST,PRE.EMBOSS version, to default
*               status field to 1 if curr number equal to 1
*Linked With  :
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 05-4-2011      KAVITHA                PACS00036008            ISSUE FIX
** 17-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 17-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.LOCKING
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.CARD.REQUEST
*--------------------------------------------------------------------------------------------------------

    FN.SS = 'F.STANDARD.SELECTION'
    F.SS = ''
    CALL OPF(FN.SS,F.SS)
    FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST = ''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)
 
    CALL GET.STANDARD.SELECTION.DETS("REDO.CARD.REQUEST",R.SS)
    Y.FIELDS = R.SS<SSL.SYS.FIELD.NAME>
    USR.FIELD.VALUE = R.SS<SSL.SYS.FIELD.NO>
    Y.COUNT = DCOUNT(Y.FIELDS,@VM)
    CHANGE @VM TO @FM IN Y.FIELDS
    CHANGE @VM TO @FM IN USR.FIELD.VALUE
    LOCATE 'PRIMARY.CARD' IN Y.FIELDS SETTING POS.VAL THEN
        Y.VAL = USR.FIELD.VALUE<POS.VAL>
    END
    LOCATE 'AUDIT.DATE.TIME' IN Y.FIELDS SETTING POS.VAL THEN
        Y.VAL1 = POS.VAL
    END
    SEL.CMD = "SELECT ":FN.REDO.CARD.REQUEST
    CALL EB.READLIST(SEL.CMD,SEL.CMD.LIST,'',NO.OF.REC.COMP,Y.ERR.LIST)
    LOOP
        REMOVE Y.ID FROM SEL.CMD.LIST SETTING POS
    WHILE Y.ID:POS
*        CALL F.READ(FN.REDO.CARD.REQUEST,Y.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,Y.ERR)
        CALL F.READU(FN.REDO.CARD.REQUEST,Y.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,Y.ERR,'');* R22 UTILITY AUTO CONVERSION
        LOOP
        WHILE Y.VAL LE Y.COUNT
            Y.CHANGE.VAL = Y.VAL - 1
            Y.CORRECT.POS = Y.VAL
            Y.VAL1 = R.REDO.CARD.REQUEST<Y.CHANGE.VAL>
            R.REDO.CARD.REQUEST<Y.CORRECT.POS> = R.REDO.CARD.REQUEST<Y.CHANGE.VAL>
            Y.VAL += 1 ;* R22 Auto conversion
        REPEAT
        CALL F.WRITE(FN.REDO.CARD.REQUEST,Y.ID,R.REDO.CARD.REQUEST)
    REPEAT
RETURN
*-------------------------------------------------------------------------------------------------------
END
