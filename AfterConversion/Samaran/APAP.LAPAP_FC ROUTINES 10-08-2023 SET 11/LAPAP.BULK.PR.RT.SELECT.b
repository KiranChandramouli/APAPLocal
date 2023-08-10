$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.BULK.PR.RT.SELECT
*------------------------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY
* Date                  Who                    Reference                        Description
* ----                  ----                     ----                              ----
* 09-08-2023           Samaran T         R22 Manual Code Conversion            BP is removed from insert file.
*-------------------------------------------------------------------------------------------------------------
    $INSERT  I_EQUATE ;*R22 MANUAL CODE CONVERSION.START
    $INSERT  I_COMMON
    $INSERT  I_GTS.COMMON
    $INSERT  I_System
    $INSERT  I_F.DATES
    $INSERT  I_F.LAPAP.BULK.PAYROLL
    $INSERT  I_F.ST.LAPAP.BULK.PAYROLL.DET
    $INSERT  I_LAPAP.BULK.PR.RT.COMMON ;*R22 MANUAL CODE CONVERSION.END

    GOSUB DO.GET.PENDING

RETURN

DO.GET.PENDING:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.BPRD : " WITH PAYROLL.ID EQ " : Y.PAYROLL.ID.L

    CALL OCOMO("RUNNING WITH SELECT LIST : " : SEL.CMD)

    GOSUB DO.UPDATE.TO.PROCESSING

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.REC)
RETURN

DO.UPDATE.TO.PROCESSING:
    Y.CNT = DCOUNT(Y.PAYROLL.ARR,@FM)
    FOR A = 1 TO Y.CNT STEP 1
        T.PAYROLL.ID = Y.PAYROLL.ARR<A>
        CALL F.READ(FN.BPR,T.PAYROLL.ID,R.PR,F.BPR,ERR.PR)

        IF R.PR THEN
            R.PR<ST.LAP39.PAYROLL.STATUS> = 'PROCESSING'
            CALL F.WRITE(FN.BPR, T.PAYROLL.ID, R.PR)
            CALL JOURNAL.UPDATE('')
            CALL OCOMO('Payroll: ' : T.PAYROLL.ID : ', updated to status PROCESSING')
        END

    NEXT A

RETURN

END
