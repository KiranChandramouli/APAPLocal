* @ValidationCode : MjotNDg2NDUyODc3OkNwMTI1MjoxNzAzMTM0NTQwNDYxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Dec 2023 10:25:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.ACH.TRANSFER.ROU(Y.ID)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.B.ACH.TRANSFER.ROU
* ODR NUMBER    : PACS0006290 - ODR-2011-01-0492
*---------------------------------------------------------------------------------------------------
* Description   : This routine will run while daily cob and create FT records
* In parameter  : Y.ID
* out parameter : none
*---------------------------------------------------------------------------------------------------
* Modification History :
*---------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE                      DESCRIPTION
* 01-06-2011      MARIMUTHU s     ODR-2011-01-0492 (PACS0006290)    Initial Creation
* 18-07-2011      MARIMUTHU S     PACS00062902
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 06-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*20/12/2023         Suresh                 R22 Manual Conversion   Change F.READ to F.READU
*-------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ACH.TRANSFER.ROU.COMMON
    $INSERT I_F.REDO.ACH.TRANSFER.DETAILS
    $INSERT I_F.FUNDS.TRANSFER

MAIN:


*   CALL F.READ(FN.REDO.ACH.TRANSFER.DETAILS,Y.ID,R.REDO.ACH.TRANSFER.DETAILS,F.REDO.ACH.TRANSFER.DETAILS,ACH.ERR)
    CALL F.READU(FN.REDO.ACH.TRANSFER.DETAILS,Y.ID,R.REDO.ACH.TRANSFER.DETAILS,F.REDO.ACH.TRANSFER.DETAILS,ACH.ERR,'') ;*R22 Manual Conversion

* PACS00062902 -S
*R.REC<FT.TRANSACTION.TYPE> = 'AC20'
* PACS00062902 -E
    R.REC<FT.DEBIT.ACCT.NO> = Y.DEB.ACCT.NO
    R.REC<FT.DEBIT.CURRENCY> = LCCY
    R.REC<FT.DEBIT.AMOUNT> = R.REDO.ACH.TRANSFER.DETAILS<REDO.ACH.INT.PAYMNT.AMT>
    R.REC<FT.DEBIT.VALUE.DATE> = R.REDO.ACH.TRANSFER.DETAILS<REDO.ACH.PAYMENT.DATE>
* PACS00062902 -S
*R.REC<FT.CREDIT.ACCT.NO> = 'DOP1402400010017'
* PACS00062902-E
    R.REC<FT.CREDIT.VALUE.DATE> = R.REDO.ACH.TRANSFER.DETAILS<REDO.ACH.PAYMENT.DATE>
    R.REC<FT.ORDERING.CUST> = R.REDO.ACH.TRANSFER.DETAILS<REDO.ACH.CLIENT.ID>
    R.REC<FT.LOCAL.REF,Y.POS.BEN> = R.REDO.ACH.TRANSFER.DETAILS<REDO.ACH.BENEFICIARY>
    R.REC<FT.LOCAL.REF,Y.POS.BEN.AC> = R.REDO.ACH.TRANSFER.DETAILS<REDO.ACH.BENEFICIARY.ACC>
    R.REC<FT.LOCAL.REF,Y.POS.BEN.ACH> = R.REDO.ACH.TRANSFER.DETAILS<REDO.ACH.BEN.BNK.CODE>

    APP.NAME='FUNDS.TRANSFER'
    OFSFUNCTION='I'
    PROCESS='PROCESS'
    OFS.SOURCE.ID='FT.ACH'
    OFSVERSION='FUNDS.TRANSFER,ACH.B34'
    GTSMODE=''
    NO.OF.AUTH='0'
    TRANSACTION.ID= ''
    OFSSTRING=''
    OFS.ERR = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.REC,OFSSTR)
    CALL OFS.POST.MESSAGE(OFSSTR,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

    IF OFS.ERR EQ '' THEN
        R.REDO.ACH.TRANSFER.DETAILS<REDO.ACH.TRANS.ACH> = 'YES'
        CALL F.WRITE(FN.REDO.ACH.TRANSFER.DETAILS,Y.ID,R.REDO.ACH.TRANSFER.DETAILS)
    END

RETURN

END
