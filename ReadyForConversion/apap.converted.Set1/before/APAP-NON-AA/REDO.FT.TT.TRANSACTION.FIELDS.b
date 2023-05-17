*-----------------------------------------------------------------------------
* <Rating>-80</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.FT.TT.TRANSACTION.FIELDS

*
* Subroutine Type : TEMPLATE.FIELDS
* Attached to     :
* Attached as     :
* Primary Purpose : Define the fields used for FT Data Capture
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date : 26 MAY 2017
* Developed by : Edwin Charles D
* PACS00716961             28-NOV-2018            GOPALA KRISHNAN R       FIX ISSUE
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

    CALL Table.defineId("@ID", T24_String)        ;* Define Table id

    neighbour = ''
    fieldName = 'DESCRIPCION'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'DEBIT.ACCT.NO'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile("ACCOUNT")

    neighbour = ''
    fieldName = 'DEBIT.THEIR.REF'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'DEBIT.VALUE.DATE'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'DEBIT.CURRENCY'
    fieldLength = '3'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")

    neighbour = ''
    fieldName = 'DEBIT.AMOUNT'
    fieldLength = '35'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'CREDIT.VALUE.DATE'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'CREDIT.AMOUNT'
    fieldLength = '35'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'CREDIT.ACCT.NO'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile("ACCOUNT")

    neighbour = ''
    fieldName = 'CREDIT.THEIR.REF'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'CURRENCY.MKT.CR'
    fieldLength = '5'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'CREDIT.CURRENCY'
    fieldLength = '3'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")

    neighbour = ''
    fieldName = 'PROCESSING.DATE'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'TRANSACTION.TYPE'
    fieldLength = '5'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'TREASURY.RATE'
    fieldLength = '10'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'CUSTOMER.SPREAD'
    fieldLength = '35'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'CUSTOMER.RATE'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'ORDERING.CUST'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.LOAN.STATUS.1'
    fieldLength = '20'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.LOAN.COND'
    fieldLength = '15'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.NO.OF.INSTAL'
    fieldLength = '10'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'AA.PART.ALLOW'
    fieldLength = '10'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.ADV.INS.CNT'
    fieldLength = '35'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.CR.CARD.NO'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.CR.ACCT.NO'
    fieldLength = '35'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.CR.CRD.STS'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.AC.STATUS'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.CLIENT.NME'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'FT.CLIENT.COD'
    fieldLength = '35'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.ACH.B.NAM'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.ACH.B.ACC'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FTST.ACH.PART'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile("REDO.ACH.PARTICIPANTS")

    neighbour = ''
    fieldName = 'PRINC.AMT.DUE'
    fieldLength = '35'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'INT.AMT.DUE'
    fieldLength = '35'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'TFS.STO.ID'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.TAX.TYPE'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.NCF.REQUIRED'
    fieldLength = '5'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field


    neighbour = ''
    fieldName = 'NCF.NUMBER'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.INITIAL.ID'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.TRAN.AUTH'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.ACTUAL.VERSIO'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.NEXT.VERSION'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.CUSTOMER'
    fieldLength = '12'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")

    neighbour = ''
    fieldName = 'L.FT.COMPANY'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile("COMPANY")

    neighbour = ''
    fieldName = 'XX.BENEFIC.NAME'
    fieldLength = '45'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.DOC.NUM'
    fieldLength = '32'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.DOC.DESC'
    fieldLength = '32'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'FT.LEGAL.ID'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'PAYMENT.DETAILS'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'AA.CHG.AMOUNT'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.CONCEPT'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'AMOUNT.CREDITED'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.COMMENTS'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.SN.PAYMTHD'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.CMPNY.ID'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.BAL.IN.LCY'
    fieldLength = '32'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.BAL.IN.USD'
    fieldLength = '32'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.MINPAY.LCY'
    fieldLength = '32'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.MINPAY.USD'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.PAY.DUE.DT'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.MSG.DESC'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.FT.MSG.CODE'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.SUN.SEQ.NO'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.TT.TAX.CODE'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.TT.WV.TAX'
    fieldLength = '5'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.TT.TAX.AMT'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'L.NCF.TAX.NUM'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
* PACS00716961 - S
*   neighbour = ''
*   fieldName = 'XX.OVERRIDE'
*   fieldLength = '65'
*   fieldType = 'A'
*   CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
* PACS00716961 - E
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')
* PACS00716961 - S
    neighbour = ''
    fieldName = 'XX.OVERRIDE'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
* PACS00716961 - E

*----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information

    RETURN
END
