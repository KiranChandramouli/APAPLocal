$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.DD.PROCESS(ENQ.DATA)
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.E.DD.PROCESS
* Primary Purpose : Clearing all record from the template 'REDO.W.DIRECT.DEBIT'
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* JEEVA T              31-10-2011         B.9-DIRECT DEBIT
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM and SM to @SM
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.W.DIRECT.DEBIT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EB.EXTERNAL.COMMON


    Y.LIST = ''
    FN.REDO.W.DIRECT.DEBIT = 'F.REDO.W.DIRECT.DEBIT'
    F.REDO.W.DIRECT.DEBIT = ''
    CALL OPF(FN.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT)
    CALL F.READ(FN.REDO.W.DIRECT.DEBIT,'FT',R.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT,Y.ERR)
    Y.LIST = R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.FT.ID>

    CHANGE @VM TO ' ' IN Y.LIST
    CHANGE @SM TO ' ' IN Y.LIST
    CHANGE @FM TO ' ' IN Y.LIST

    ENQ.DATA<2,-1> ='@ID'
    ENQ.DATA<3,-1> ='EQ'
    ENQ.DATA<4,-1> = Y.LIST
RETURN
END
