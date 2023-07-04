* @ValidationCode : MjotMTY2MjU5MzY0NjpDcDEyNTI6MTY4MTI3NjU0NjM3NzpJVFNTOi0xOi0xOi00OToxOnRydWU6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -49
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE LATAM.CARD.INTERFACE.FIELDS
*-----------------------------------------------------------------------------
*** FIELD definitions FOR TEMPLATE
* @author adinesh@temenos.com
* @stereotype fields
* @uses C_METHODS
* @uses C_PROPERTIES
* @package infra.eb
*!
*-----------------------------------------------------------------------------
* Revision Histroy :
*   -Date-           -Who-          -Reference-       -Description-
* 05/09/2008       A.DINESH                          Initial Version
* 22/09/2010       SWAMINATHAN    ODR-2010-03-0400   Changed to R9 standards
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 FM TO @FM
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.EB.CHANNEL
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.TRANSACTION
*-----------------------------------------------------------------------------

    ID.F = "CARD.INTF.ID" ; ID.N = "10" ; ID.T = "A"          ;*Card Interface ID
    ID.CHECKFILE = "EB.CHANNEL"

    GOSUB INIT.DESC
    GOSUB TRANS.FIELDS
    GOSUB OTHER.FIELDS
    GOSUB RESERVED.FIELDS

RETURN
*-----------------------------------------------------------------------------
INIT.DESC:

    neighbour = ''
    fieldName = 'XX.LL.DESCRIPTION'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.LL.SHORT.DESCRP'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX<COMP.ID.REJ.AC'
    fieldLength = '11'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('COMPANY')

    neighbour = ''
    fieldName = 'XX-REJ.SUS.AC.OUR'
    fieldLength = '19'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('ACCOUNT')

    neighbour = ''
    fieldName = 'XX>REJ.SUS.AC.OTH'
    fieldLength = '19'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('ACCOUNT')

    neighbour = ''
    fieldName = 'FTP.ID'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

RETURN

*-----------------------------------------------------------------------------
TRANS.FIELDS:

*External ID
    neighbour = ''
    fieldName = 'EXTERNAL.ID'
    fieldLength = '10'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Withdrawal Online Limit
    neighbour = ''
    fieldName = 'WD.ONL.TXN.LIMIT'
    fieldLength = '13'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Withdrawal Offline Limit
    neighbour = ''
    fieldName = 'WD.OFL.TXN.LIMIT'
    fieldLength = '13'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Daily Online Limit
    neighbour = ''
    fieldName = 'WD.ONL.DAY.LIMIT'
    fieldLength = '13'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Daily Offline Limit
    neighbour = ''
    fieldName = 'WD.OFL.DAY.LIMIT'
    fieldLength = '13'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Max Withdrawal Limit Our ATM
    neighbour = ''
    fieldName = 'DP.CS.THAMT.OUR'
    fieldLength = '13'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Percentage of Cash Withdrawal Our ATM
    neighbour = ''
    fieldName = 'DP.CS.THPCT.OUR'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*No of Day's to Hold Fund Our ATM
    neighbour = ''
    fieldName = 'DP.CS.HDAYS.OUR'
    fieldLength = '9'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.DP.CS.TXN.ID.OUR'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('TRANSACTION')
*Max Withdrawal Limit Other ATM
    neighbour = ''
    fieldName = 'DP.CS.THAMT.OTH'
    fieldLength = '13'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Percentage of Cash Withdrawal Other ATM
    neighbour = ''
    fieldName = 'DP.CS.THPCT.OTH'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*No of Days to Hold Fund Other ATM
    neighbour = ''
    fieldName = 'DP.CS.HDAYS.OTH'
    fieldLength = '9'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.DP.CS.TXN.ID.OTH'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('TRANSACTION')
*Max Withdrawal for Cheque Deposited at Our ATM
    neighbour = ''
    fieldName = 'DP.CQ.THAMT.OUR'
    fieldLength = '13'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Percentage of Cash Withdrawal on Cheque deposits in Our ATM
    neighbour = ''
    fieldName = 'DP.CQ.THPCT.OUR'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*No of Days to Hold Fund Our ATM Cheques
    neighbour = ''
    fieldName = 'DP.CQ.HDAYS.OUR'
    fieldLength = '9'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'DP.CQ.TXN.ID.OUR'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('TRANSACTION')
*Max Withdrawal for Cheque Deposited at Other ATM
    neighbour = ''
    fieldName = 'DP.CQ.THAMT.OTH'
    fieldLength = '13'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*Percentage of Cash Withdrawal on Check deposits in Other ATM
    neighbour = ''
    fieldName = 'DP.CQ.THPCT.OTH'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*No of Days to Hold Fund Other ATM Cheques
    neighbour = ''
    fieldName = 'DP.CQ.HDAYS.OTH'
    fieldLength = '9'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'DP.CQ.TXN.ID.OTH'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('TRANSACTION')
*Maximum Deposit Amt
    neighbour = ''
    fieldName = 'MAX.DEPOSIT.AMT'
    fieldLength = '13'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

RETURN
*-----------------------------------------------------------------------------
OTHER.FIELDS:

    neighbour = ''
    fieldName = 'LOG.DETAIL'
    fieldLength = '5'
    fieldType = ''
    fieldType<2> = "FULL_ERROR_NULL"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CARD.TYPE'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CARD.TYPE')

    neighbour = ''
    fieldName = 'BIN'
    fieldLength = '6'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CCY.OF.BIN'
    fieldLength = '3'
    fieldType = 'CCY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'DA.ATMWDL.LIM'
    fieldLength = '10'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'MX.ATM.TRAN.LIM'
    fieldLength = '10'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'DA.ATM.TRAN.QTY'
    fieldLength = '10'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'MN.ATM.TRAN.QTY'
    fieldLength = '10'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'DA.POSWDL.LIM'
    fieldLength = '10'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'MX.POS.TRAN.LIM'
    fieldLength = '10'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'DA.POS.TRAN.QTY'
    fieldLength = '10'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'MN.POS.TRAN.QTY'
    fieldLength = '10'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

RETURN
*-----------------------------------------------------------------------------
RESERVED.FIELDS:
* Reserved fields
*-----------------------------------------------------------------------------

    fieldName='RESERVED.20'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.19'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.18'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.17'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.16'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.15'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.14'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.13'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.12'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.11'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.10'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.9'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.8'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.7'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.6'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.5'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.4'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.3'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.2'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.1'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A':@FM:'':@FM:'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType = 'A':@FM:'':@FM:'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
