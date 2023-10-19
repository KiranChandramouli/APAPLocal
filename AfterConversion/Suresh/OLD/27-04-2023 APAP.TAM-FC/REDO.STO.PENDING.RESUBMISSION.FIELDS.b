* @ValidationCode : MjotMTQ5NDA5MjI5NDpDcDEyNTI6MTY4MTM4MjM4MzQxMDozMzNzdTotMTotMTowOjA6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:09:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.STO.PENDING.RESUBMISSION.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author nskumar@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("REDO.STO.PENDING.RESUBMISSION", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------

    neighbour = ''
    fieldName = 'TRANSACTION.TYPE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DEBIT.ACCT.NO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.DEBIT.ACCT.NO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CURRENCY.MKT.DR'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DEBIT.CURRENCY'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DEBIT.AMOUNT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DEBIT.VALUE.DATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.DEBIT.VDATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DEBIT.THEIR.REF'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CREDIT.THEIR.REF'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CREDIT.ACCT.NO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CURRENCY.MKT.CR'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CREDIT.CURRENCY'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CREDIT.AMOUNT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CREDIT.VALUE.DATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'TREASURY.RATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'NEG.DEALER.REFNO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'PROCESSING.DATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.ORDERING.CUST'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.ORDERING.CUS'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.ORDERING.BANK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.ORDERING.BK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.ACCT.WITH.BANK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.ACCT.WITH.BK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'BEN.ACCT.NO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.BEN.ACCT.NO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.BEN.CUSTOMER'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.BEN.CUSTOMER'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.BEN.BANK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.BEN.BANK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CHEQUE.NUMBER'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.PAYMENT.DETAILS'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.PAY.DETAILS'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'BC.BANK.SORT.CODE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'RECEIVER.BANK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.REC.CORR.BANK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.INTERMED.BANK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.INTMED.BANK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'MAILING'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'PAY.METHOD'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'BEN.OUR.CHARGES'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.BEN.OUR.CHARGES'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CHARGES.ACCT.NO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CHARGE.COM.DISPLAY'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'COMMISSION.CODE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX<COMMISSION.TYPE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX-COMMISSION.AMT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX>COMMISSION.FOR'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CHARGE.CODE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX<CHARGE.TYPE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX-CHARGE.AMT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX>CHARGE.FOR'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CUSTOMER.SPREAD'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'BASE.CURRENCY'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'PROFIT.CENTRE.CUST'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'PROFIT.CENTRE.DEPT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'RETURN.TO.DEPT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'PRIORITY.TXN'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.BK.TO.BK.INFO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.BK.TO.BK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'EXPOSURE.DATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'FED.FUNDS'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'POSITION.TYPE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'NO.OF.BATCH.ITEMS'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.FREE.TEXT.MSGTO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.MESSAGE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX<TAX.TYPE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX>TAX.AMT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'AMOUNT.DEBITED'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'AMOUNT.CREDITED'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'TOTAL.CHARGE.AMT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'TOTAL.TAX.AMOUNT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CUSTOMER.RATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.REC.CORR.BK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'INWARD.PAY.TYPE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.SEND.CORR.BK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'TELEX.FROM.CUST'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DELIVERY.INREF'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.DELIVERY.OUTREF'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CREDIT.COMP.CODE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DEBIT.COMP.CODE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'STATUS'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DELIVERY.MKR'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'BATCH.NO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'ACCT.WIT.BK.ACNO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'LOC.AMT.DEBITED'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'LOC.AMT.CREDITED'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'LOC.TOT.TAX.AMT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'LOCAL.CHARGE.AMT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'LOC.POS.CHGS.AMT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'MKTG.EXCH.PROFIT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'RATE.INPUT.MKR'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CUST.GROUP.LEVEL'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DEBIT.CUSTOMER'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CREDIT.CUSTOMER'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'SEND.PAYMENT.Y.N'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DR.ADVICE.REQD.Y.N'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CR.ADVICE.REQD.Y.N'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DEAL.MARKET'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CHARGED.CUSTOMER'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.REASON.OVE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DEALER.DESK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'RECALC.FWD.RATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'RETURN.CHEQUE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'DRAWN.ACCOUNT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'ACCOUNTING.DATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.INSTRCTN.CODE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'COLL.REM.BK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'EXPECTED.RECS.ID'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'TOT.REC.COMM'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'TOT.REC.COMM.LCL'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'TOT.REC.CHG'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'TOT.REC.CHG.LCL'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CHEQ.TYPE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX<RELATED.MSG'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX>XX.TIME.IND'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.TIME.IND'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX<SEND.TO.PARTY'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX-XX.BK.TO.BK.OUT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX>MESSAGE.TYPE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'REVERSAL.MKR'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'RELATED.REF'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.INSTR.CODE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.PROCESS.ERR'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.SWIFT.MSG'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'ACCT.WITH.BANK.ACC'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.ACCT.BANK.ACC'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'REC.CORR.BANK.ACC'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.REC.CORR.ACC'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'INTERMED.BANK.ACC'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.INTERMED.ACC'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'INSTRUCTED.AMT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.INTERMED.BK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.EXCH.RATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'RATE.FIXING'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'COVER.METHOD'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.3RD.REIMB.BK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.3RD.REIMB.ACC'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'MT103.TYPE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'EXTEND.FORMAT'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.EXTEND.INFO'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'RATE.FIXING.IND'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'INW.SEND.BIC'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.IN.SEND.CHG'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.REC.CHG'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'AC.CHG.REQ.ID'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'TOT.REC.CHG.CRCCY'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'TOT.SND.CHG.CRCCY'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CHG.ADVICE.MSG'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'EXPECTED.COVER.ID'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'NETTING.STATUS'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'AUTH.DATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'BK.OPERATION.CODE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'AM.INFLOW.RATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'PARENT.TXN.ID'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'ROUND.TYPE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'BENEFICIARY.ID'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX<MSG.TYPE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX>MSG.DATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.SIGNATORY'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'CARD.NUMBER'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.CARD.TXN.DETAIL'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.C.ORD.BK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.C.INTMED.BK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.C.ACC.WIT.BK'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'IN.C.BK.T.BK.IN'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'END.DATE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'RESERVED.1'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.STMT.NOS'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*CALL Table.setAuditPosition         ;* Poputale audit information
RETURN
END
