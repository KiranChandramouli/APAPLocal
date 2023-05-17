*--------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.S.CALC.ACH.TXNTYPE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.S.CALC.ACH.TXNTYPE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine to default the transaction type
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 29 Oct 2010     SWAMINATHAN           ODR-2009-12-0290        Initial Creation
* 01 AUG 2011     KAVITHA               PACS00089082            PACS00089082 FIX
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.BENEFICIARY
*--------------------------------------------------------------------------------------------------------

    GOSUB OPEN.FILES
    GOSUB PROCESS
    RETURN
*--------------------------------------------------------------------------------------------------------
OPEN.FILES:
************
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AI.REDO.ARCIB.PARAMETER='F.AI.REDO.ARCIB.PARAMETER'

    CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,ERR)

    FN.BENEFICIARY='F.BENEFICIARY'
    F.BENEFICIARY =''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

    FN.BENEFICIARY.HIS ='F.BENEFICIARY$HIS'
    F.BENEFICIARY.HIS =''
    CALL OPF(FN.BENEFICIARY.HIS,F.BENEFICIARY.HIS)

    LF.APP = 'BENEFICIARY'
    LF.FLD = 'L.BEN.PROD.TYPE'
    LF.POS = ''
    CALL MULTI.GET.LOC.REF(LF.APP,LF.FLD,LF.POS)

    RETURN
*-----------------------------------------------------------------------------------------------------------
PROCESS:
*********

    CALL F.READ(FN.FUNDS.TRANSFER,COMI,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUND.ERR)
    IF NOT(R.FUNDS.TRANSFER) THEN
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,COMI,R.FUNDS.TRANSFER.HIS,Y.ERR.FTHIS)
        R.FUNDS.TRANSFER=R.FUNDS.TRANSFER.HIS
    END
    Y.BENEFICIARY.ID=R.FUNDS.TRANSFER<FT.BENEFICIARY.ID>
    CALL F.READ(FN.BENEFICIARY,Y.BENEFICIARY.ID,R.BENEFICIARY,F.BENEFICIARY,ERR)
    IF R.BENEFICIARY EQ '' THEN
        Y.BEN.HIS = Y.BENEFICIARY.ID
        CALL EB.READ.HISTORY.REC(F.BENEFICIARY.HIS,Y.BEN.HIS,R.BENEFICIARY,HIS.ERR)
    END
    Y.T24.TXN=R.BENEFICIARY<ARC.BEN.LOCAL.REF,LF.POS>
    Y.T24.TXN.TYPE.LIST=R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.ACH.PAY.TYPE>
    Y.ACH.TXN.TYPE.LIST=R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.ACH.CODE>

    LOCATE Y.T24.TXN IN Y.T24.TXN.TYPE.LIST<1,1> SETTING POS THEN
        COMI=Y.ACH.TXN.TYPE.LIST<1,POS>
    END
    RETURN
*-----------------------------------------------------------------------------------------------------------
END

