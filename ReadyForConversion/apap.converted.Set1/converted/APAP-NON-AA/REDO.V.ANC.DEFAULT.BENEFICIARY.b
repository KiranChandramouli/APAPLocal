SUBROUTINE REDO.V.ANC.DEFAULT.BENEFICIARY
*----------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Bharath G
*Program   Name    :REDO.V.ANC.DEFAULT.BENEFICIARY
*----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who             Reference            Description
* 16-APR-2010          Bharath G       PACS00055029         Initial Creation
* 09-SEP-2011          Marimuthu S     PACS00121111         Version name changed
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_System
    $INSERT I_F.REDO.MTS.DISBURSE
*----------------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
*Initialize all the variables

    FN.REDO.MTS.DISBURSE = 'F.REDO.MTS.DISBURSE'
    F.REDO.MTS.DISBURSE = ''
    CALL OPF(FN.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE)

    LREF.APP = 'FUNDS.TRANSFER'
    LREF.FIELDS = 'BENEFIC.NAME':@VM:'L.FT.CONCEPT'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    POS.BENEFIC.NAME        = LREF.POS<1,1>
    POS.CONCEPT             = LREF.POS<1,2>

RETURN
********
PROCESS:
********
* Updating acocunt id in local template

    Y.ID = System.getVariable('CURRENT.FT')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.ID = ""
    END

    IF Y.ID EQ '' THEN
        RETURN
    END
    CALL F.READ(FN.REDO.MTS.DISBURSE,Y.ID,R.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE,Y.ERR)
    IF R.REDO.MTS.DISBURSE THEN
        R.NEW(FT.LOCAL.REF)<1,POS.BENEFIC.NAME,1> = R.REDO.MTS.DISBURSE<MT.BENEFICIARY,1>
        R.NEW(FT.LOCAL.REF)<1,POS.BENEFIC.NAME,2> = R.REDO.MTS.DISBURSE<MT.BENEFICIARY,2>
        IF PGM.VERSION EQ ',CHQ.OTHERS.LOAN.DUM' THEN
            R.NEW(FT.PAYMENT.DETAILS)             = R.REDO.MTS.DISBURSE<MT.NARRATIVE>
            R.NEW(FT.LOCAL.REF)<1,POS.CONCEPT>    = R.REDO.MTS.DISBURSE<MT.REMARKS>
        END
        ELSE
            R.NEW(FT.PAYMENT.DETAILS)             = R.REDO.MTS.DISBURSE<MT.PAYMENT.DETAILS>
        END
    END

RETURN
END
