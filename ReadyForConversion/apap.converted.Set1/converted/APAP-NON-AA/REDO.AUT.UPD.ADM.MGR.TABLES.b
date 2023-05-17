SUBROUTINE REDO.AUT.UPD.ADM.MGR.TABLES
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: MARIMUTHU S
* PROGRAM NAME: REDO.AUT.UPD.ADM.MGR.TABLES
* ODR NO      : PACS00062902
*----------------------------------------------------------------------
*DESCRIPTION: This routine is AUTH routine attached with FT,CHQ.OTHERS.LOAN.DUM to update admin as well as manager chq tables

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18-07-2011  Marimuthu                      PACS00062902
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT

    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    IF APPLICATION EQ "FUNDS.TRANSFER" THEN
        VAR.CR.ACCT.NO = R.NEW(FT.CREDIT.ACCT.NO)

        CALL F.READ(FN.ACCOUNT,VAR.CR.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        VAR.CUST = R.ACCOUNT<AC.CUSTOMER>
        IF NOT(VAR.CUST) THEN
            CALL REDO.V.AUT.UPD.TABLES
        END ELSE
            CALL REDO.V.AUT.UPD.MGRTABLES
        END
    END

RETURN
*--------------------------------------------------
END
