*-----------------------------------------------------------------------------
* <Rating>-25</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.LIST.AFFI.FOR.INDIV.SELECT
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This is an batch routine used to process the records from CUSTOMER file with required
**                        selection and generate report in the parameterized out folder
*
* Developed By          : Shiva Prasad Y, Capgemini
*
* Development Reference : 786892-218-MV33
*
* Attached To           : Batch - BNK/REDO.B.LIST.AFFI.FOR.INDIV
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
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_REDO.B.LIST.AFFI.FOR.INDIV.COMMON
    $INCLUDE T24.BP I_F.RELATION.CUSTOMER
    $INCLUDE TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INCLUDE T24.BP I_F.DATES
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**

    FN.CHK.DIR=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID= R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>:'_':R.DATES(EB.DAT.LAST.WORKING.DAY):'.csv'
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END

    GOSUB PROCESS.PARA

    RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    CURR.MONTH = TODAY[5,2]
    CURR.MONTH = TRIM(CURR.MONTH,'0','L')
    LOCATE CURR.MONTH IN REP.GEN.MONTHS<1,1,1> SETTING FOUND.POS ELSE
        RETURN
    END

*    SEL.CMD = 'SELECT ':FN.RELATION.CUSTOMER
*    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)


    CALL F.READ(FN.RELATION.CUSTOMER,Y.APAP.CUST.NO,R.APAP.RC,F.RELATION.CUSTOMER,Y.APAP.CUS.ERR)
    SEL.LIST   =R.APAP.RC<EB.RCU.OF.CUSTOMER>
    CHANGE VM TO FM IN SEL.LIST

    SEL.LIST =SORT(SEL.LIST)
    NO.OF.REC=DCOUNT(SEL.LIST,FM)
    Y.REC.CNT=1
    LOOP
    WHILE Y.REC.CNT LE NO.OF.REC
        IF SEL.LIST<Y.REC.CNT> EQ SEL.LIST<Y.REC.CNT-1> THEN
            DEL SEL.LIST<Y.REC.CNT>
            NO.OF.REC-=1
            Y.REC.CNT--
        END
        Y.REC.CNT++
    REPEAT

    CALL BATCH.BUILD.LIST('',SEL.LIST)

    RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
