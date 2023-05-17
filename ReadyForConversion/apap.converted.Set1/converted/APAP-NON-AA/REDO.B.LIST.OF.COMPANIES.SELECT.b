SUBROUTINE REDO.B.LIST.OF.COMPANIES.SELECT
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Mayurika Tiwary
*  Program   Name    :REDO.B.LIST.OF.COMPANIES.SELECT
***********************************************************************************
*Description: REDO.B.LIST.OF.COMPANIES needs to be created to process the report
*             which contains companies where Directors and Officers have 10% or more share.
*****************************************************************************
*linked with: BNK/REDO.B.LIST.OF.COMPANIES
*In parameter: N/A
*Out parameter: N/A
**********************************************************************
* Modification History :
*----------------------------------------------------------------------
*------------
INSERT.FILES:
*------------
*Here all the mandatory insert files with there respective locations are listed.

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.LIST.OF.COMPANIES.COMMON

*---------
MAIN.PARA:
*---------
*The execution of the program begins here.
    GOSUB CHECK.GEN.FILE
    GOSUB PROCESS.PARA

RETURN

*--------------
CHECK.GEN.FILE:
*--------------

    FN.CHK.DIR=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    EXTRACT.FILE.ID=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>:'_': R.DATES(EB.DAT.LAST.WORKING.DAY):'.csv'
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID

    END

RETURN
*------------
PROCESS.PARA:
*------------
*Here the current monthly customers are selected.

    CURR.MONTH = TODAY[5,2]
    CURR.MONTH = CURR.MONTH + 1 - 1

    LOCATE CURR.MONTH IN REP.GEN.MONTHS<1,1,1> SETTING FOUND.POS ELSE
        RETURN
    END

*    SEL.CMD = "SELECT ": FN.RELATION.CUSTOMER
*    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    CALL F.READ(FN.RELATION.CUSTOMER,Y.APAP.CUST.NO,R.APAP.RC,F.RELATION.CUSTOMER,Y.APAP.CUS.ERR)

    SEL.LIST=R.APAP.RC<EB.RCU.OF.CUSTOMER>
    CHANGE @VM TO @FM IN SEL.LIST
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
