* @ValidationCode : MjoxNDE4NzQ3MDYwOkNwMTI1MjoxNjg0ODU0Mzc4OTYyOklUU1M6LTE6LTE6Njc0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 674
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.ADMIN.CHEQUE(Y.ID.LIST)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.B.ADMIN.CHEQUE
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This is multi threaded COB routine to update the template REDO.ADMIN.CHEQUE.DETAILS
* In parameter  : Y.ID.LIST
* out parameter : none
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE        WHO                REFERENCE          DESCRIPTION
* 11-01-2011    MARIMUTHU s        ODR-2009-10-0795   Initial Creation
* 15-07-2011    MARIMUTHU S        PACS00062902
* 18-07-2013    Vignesh Kumaar R   PACS00298102       DEBIT ENTRIES SHOULD NOT BE RECORDED AS THIS IS RELATED TO TAX
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 06-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ADMIN.CHEQUE.DETAILS
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_REDO.B.ADMIN.CHEQUE.COMMON
    $INSERT I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------
MAIN:

    GOSUB PARSE.VALUES
RETURN
*-----------------------------------------------------------------------------
PARSE.VALUES:
*-----------------------------------------------------------------------------

    Y.STMT.ID = FIELD(Y.ID.LIST,'*',7)
    Y.CR.INT.AMT = FIELD(Y.ID.LIST,'*',6)

* Fix for PACS00298102 [DEBIT ENTRIES SHOULD NOT BE RECORDED AS THIS IS RELATED TO TAX]

    IF Y.CR.INT.AMT[1,1] EQ '-' THEN
        RETURN
    END

* End of Fix

    CALL F.READ(FN.STMT.ENTRY.DETAIL,Y.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY.DETAIL,STM.ERR)
    Y.AGENCY = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
    Y.VAL.DATE = R.STMT.ENTRY<AC.STE.VALUE.DATE>
    Y.TRANS.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
    Y.CR.ACCT = FIELD(Y.TRANS.REF,'-',1)

    CALL F.READ(FN.AZ.ACCOUNT,Y.CR.ACCT,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.AC.ERR)
* PACS00062902 -S
    IF NOT(R.AZ.ACCOUNT) THEN
        CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT,Y.CR.ACCT,R.AZ.ACCOUNT,AZ.HIS.ERR)
    END
* PACS00062902 -E
    IF R.AZ.ACCOUNT THEN
        Y.CUSTOMER = R.AZ.ACCOUNT<AZ.CUSTOMER>
        Y.INT.RATE = R.AZ.ACCOUNT<AZ.INTEREST.RATE>
        Y.INT.RATE = FMT(Y.INT.RATE,'L2#6')
        Y.INT.AMT = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.DEP.AMT>
        Y.BEN.NAME = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.BEN.NAME>

        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
        Y.SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
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
* PACS00062902 - E
    END

RETURN
*-----------------------------------------------------------------------------
WRITE.VALUES:
*-----------------------------------------------------------------------------
    R.REC.TEMP.VAL = ''
    R.REC.TEMP.VAL<REDO.AD.CHQ.AGENCY> = Y.AGENCY
    R.REC.TEMP.VAL<REDO.AD.CHQ.PAYMENT.DATE> = Y.VAL.DATE
    R.REC.TEMP.VAL<REDO.AD.CHQ.CLIENT.ID> = Y.CUSTOMER
    R.REC.TEMP.VAL<REDO.AD.CHQ.DEPOSIT.NO> = Y.CR.ACCT
    R.REC.TEMP.VAL<REDO.AD.CHQ.INTEREST.RATE> = Y.INT.RATE
    R.REC.TEMP.VAL<REDO.AD.CHQ.INT.PAYMNT.AMT> = Y.CR.INT.AMT
    R.REC.TEMP.VAL<REDO.AD.CHQ.CHEQ.PRINT> = 'NO'
    R.REC.TEMP.VAL<REDO.AD.CHQ.CHEQ.BENEFICIARY> = Y.BEN.NAME

    Y.MAIN.ID = Y.CR.ACCT:'-':Y.VAL.DATE
    CALL F.WRITE(FN.REDO.ADMIN.CHEQUE.DETAILS,Y.MAIN.ID,R.REC.TEMP.VAL)

RETURN
*-----------------------------------------------------------------------------
END
