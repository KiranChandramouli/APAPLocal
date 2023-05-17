SUBROUTINE REDO.B.RISK.GROUP.MEMBERS.SELECT
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN4-GR03
*
* Attached To           : Batch - BNK/REDO.B.RISK.GROUP.MEMBERS
*
* Attached As           : Multi Threaded Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#2 : NA
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* REGN4-GR03             Kalyani L K                     2014-02-14           Initial Draft
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.DATES

    $INSERT I_REDO.B.RISK.GROUP.MEMBERS.COMMON

*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**
    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    CURR.MONTH = TODAY[5,2]
    CURR.MONTH = CURR.MONTH + 1 - 1

    LOCATE CURR.MONTH IN FIELD.GEN.VAL<1> SETTING FOUND.POS ELSE
        RETURN
    END


    FN.CHK.DIR=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    Y.LWD = R.DATES(EB.DAT.LAST.WORKING.DAY)
    EXTRACT.FILE.ID=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>:Y.LWD:'.txt'

    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID

    END

    Y.SEL.REL=FIELD.REV.VAL
    CHANGE @FM TO ' ' IN Y.SEL.REL
    SEL.CMD = "SELECT ":FN.RELATION.CUSTOMER:" WITH IS.RELATION EQ ":Y.SEL.REL

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
