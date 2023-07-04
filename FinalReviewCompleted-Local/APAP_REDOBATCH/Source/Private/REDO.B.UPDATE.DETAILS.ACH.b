* @ValidationCode : MjoxNjQ4MTI4MDQ3OkNwMTI1MjoxNjg0ODU0NDAxMjg1OklUU1M6LTE6LTE6NTc2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 576
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPDATE.DETAILS.ACH(Y.ID.LIST)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.B.UPDATE.DETAILS.ACH
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This is multi-threaded COB routine will update the details of interest payments
* into the template REDO.ACH.TRANSFER.DETAILS
* In parameter  : Y.ID.LIST
* out parameter : none
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 13-01-2011      MARIMUTHU s     ODR-2009-10-0795  Initial Creation
* 15-07-2011      MARIMUTHU S     PACS00062902
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.ACH.TRANSFER.DETAILS
    $INSERT I_F.STMT.ENTRY
    $INSERT I_REDO.B.UPDATE.DETAILS.ACH.COMMON
    $INSERT I_F.CUSTOMER
*-----------------------------------------------------------------------------
MAIN:

    GOSUB PARSE.VALUES
RETURN
*-----------------------------------------------------------------------------
PARSE.VALUES:
*-----------------------------------------------------------------------------

    Y.STMT.ID = FIELD(Y.ID.LIST,'*',7)
    Y.CR.INT.AMT = FIELD(Y.ID.LIST,'*',6)

    CALL F.READ(FN.STMT.ENTRY.DETAIL,Y.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY.DETAIL,STM.ERR)
    Y.AGENCY = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
    Y.VAL.DATE = R.STMT.ENTRY<AC.STE.VALUE.DATE>
    Y.TRANS.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
    Y.CR.ACCT = FIELD(Y.TRANS.REF,'-',1)
* PACS00062902 -S
    CALL F.READ(FN.AZ.ACCOUNT,Y.CR.ACCT,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.AC.ERR)
    IF NOT(R.AZ.ACCOUNT) THEN
        CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT,Y.CR.ACCT,R.AZ.ACCOUNT,AZ.HIS.ERR)
    END
* PACS00062902 -E
    IF R.AZ.ACCOUNT THEN
        Y.CUSTOMER = R.AZ.ACCOUNT<AZ.CUSTOMER>
        Y.INT.AMT = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.DEP.AMT>
        Y.BEN.NAME = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.BEN.NAME>
        Y.BEN.ACC = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.BEN.ACC>
        Y.BNK.CODE = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.BNK.CODE>

        GOSUB WRITE.VALUES
    END ELSE
* PACS00062902 -S
        Y.STMT.ID = FIELD(Y.ID.LIST,'*',2)
        CALL F.READ(FN.STMT.ENTRY,Y.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ERR)
        Y.AGENCY = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
        Y.VAL.DATE = R.STMT.ENTRY<AC.STE.VALUE.DATE>
        Y.TRANS.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
        Y.CR.ACCT = FIELD(Y.TRANS.REF,'-',1)

        CALL F.READ(FN.AZ.ACCOUNT,Y.CR.ACCT,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.AC.ERR)
        IF NOT(R.AZ.ACCOUNT) THEN
            CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT,Y.CR.ACCT,R.AZ.ACCOUNT,AZ.HIS.ERR)
        END
        IF R.AZ.ACCOUNT THEN
            Y.CUSTOMER = R.AZ.ACCOUNT<AZ.CUSTOMER>
            Y.INT.RATE = R.AZ.ACCOUNT<AZ.INTEREST.RATE>
            Y.INT.RATE = FMT(Y.INT.RATE,'L2#6')
            Y.INT.AMT = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.DEP.AMT>
            Y.BEN.NAME = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.BEN.NAME>

            CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
            Y.SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
            GOSUB WRITE.VALUES
        END
* PACS00062902 -E
    END

RETURN
*-----------------------------------------------------------------------------
WRITE.VALUES:
*-----------------------------------------------------------------------------
    R.REC.TEMP.VAL = ''
    R.REC.TEMP.VAL<REDO.ACH.AGENCY> = Y.AGENCY
    R.REC.TEMP.VAL<REDO.ACH.PAYMENT.DATE> = Y.VAL.DATE
    R.REC.TEMP.VAL<REDO.ACH.CLIENT.ID> = Y.CUSTOMER
    R.REC.TEMP.VAL<REDO.ACH.DEPOSIT.NO> = Y.CR.ACCT
    R.REC.TEMP.VAL<REDO.ACH.INT.PAYMNT.AMT> = Y.CR.INT.AMT
    R.REC.TEMP.VAL<REDO.ACH.BENEFICIARY> = Y.BEN.NAME
    R.REC.TEMP.VAL<REDO.ACH.BENEFICIARY.ACC> = Y.BEN.ACC
    R.REC.TEMP.VAL<REDO.ACH.BEN.BNK.CODE> = Y.BNK.CODE
    R.REC.TEMP.VAL<REDO.ACH.TRANS.ACH> = 'NO'

    Y.MAIN.ID = Y.CR.ACCT:'-':Y.VAL.DATE
    CALL F.WRITE(FN.REDO.ACH.TRANSFER.DETAILS,Y.MAIN.ID,R.REC.TEMP.VAL)

RETURN
*-----------------------------------------------------------------------------
END
