SUBROUTINE REDO.AUT.GET.TEMP.ID.B34.CS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.AUT.GET.TEMP.ID.B34
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This is input routine will make the changes into the tempalte REDO.ADMIN.CHEQUE.DETAILS
* In parameter  : none
* out parameter : none
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 13-01-2011      MARIMUTHU s        ODR-2009-10-0795  Initial Creation
* 10-10-2011      JEEVA T            PACS00139330
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DEAL.SLIP.FORMAT
    $INSERT I_GTS.COMMON
    $INSERT I_RC.COMMON
    $INSERT I_System
    $INSERT I_F.REDO.ADMIN.CHEQUE.DETAILS
    $INSERT I_F.REDO.TEMP.UPDATE.CUS.AC
    $INSERT I_F.FUNDS.TRANSFER


MAIN:

    FN.REDO.ADMIN.CHEQUE.DETAILS = 'F.REDO.ADMIN.CHEQUE.DETAILS'
    F.REDO.ADMIN.CHEQUE.DETAILS = ''
    CALL OPF(FN.REDO.ADMIN.CHEQUE.DETAILS,F.REDO.ADMIN.CHEQUE.DETAILS)

    FN.REDO.TEMP.UPDATE.CUS.AC = 'F.REDO.TEMP.UPDATE.CUS.AC'
    F.REDO.TEMP.UPDATE.CUS.AC = ''
    CALL OPF(FN.REDO.TEMP.UPDATE.CUS.AC,F.REDO.TEMP.UPDATE.CUS.AC)

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:

    Y.ORDER.CUS = R.NEW(FT.ORDERING.CUST)
    Y.CHQ.NO = R.NEW(FT.CREDIT.THEIR.REF)
    CALL F.READ(FN.REDO.TEMP.UPDATE.CUS.AC,Y.ORDER.CUS,R.TEMP.REC,F.REDO.TEMP.UPDATE.CUS.AC,ERR.TEMP)
    Y.AC.IDS = R.TEMP.REC<REDO.RG.AC.ID>
    Y.AC.DATE = R.TEMP.REC<REDO.RG.AC.DATE>
    Y.CNT = DCOUNT(Y.AC.IDS,@VM)
    IF OFS$OPERATION EQ 'PROCESS' THEN
        OFS$DEAL.SLIP.PRINTING = 1
*        Y.SLIP.ID = 'ADMIN.COVER.DET'
*        CALL PRODUCE.DEAL.SLIP(Y.SLIP.ID)
        Y.SLIP.ID = 'ADMIN.CHQ.PR.CS'
        CALL PRODUCE.DEAL.SLIP(Y.SLIP.ID)
        VAR.HOLD.ID = C$LAST.HOLD.ID
        CHANGE ',' TO @VM IN VAR.HOLD.ID
        FLAG = ''
        LOOP
        WHILE Y.CNT GT 0 DO
            FLAG += 1
            Y.MAIN.ID = Y.AC.IDS<1,FLAG>:'-':Y.AC.DATE<1,FLAG>
            CALL F.READ(FN.REDO.ADMIN.CHEQUE.DETAILS,Y.MAIN.ID,R.MAIN.TEMP.REC,F.REDO.ADMIN.CHEQUE.DETAILS,MA.TEM.ER)
            R.MAIN.TEMP.REC<REDO.AD.CHQ.CHEQ.NO.REF> = Y.CHQ.NO
            R.MAIN.TEMP.REC<REDO.AD.CHQ.CHEQ.PRINT> = 'YES'
            R.MAIN.TEMP.REC<REDO.AD.CHQ.FT.NO.REF> = ID.NEW
            R.MAIN.TEMP.REC<REDO.AD.CHQ.HLD.CNTRL.ID> = VAR.HOLD.ID
            CALL F.WRITE(FN.REDO.ADMIN.CHEQUE.DETAILS,Y.MAIN.ID,R.MAIN.TEMP.REC)
            Y.CNT -= 1
        REPEAT
    END
RETURN

PGM.END:

END
