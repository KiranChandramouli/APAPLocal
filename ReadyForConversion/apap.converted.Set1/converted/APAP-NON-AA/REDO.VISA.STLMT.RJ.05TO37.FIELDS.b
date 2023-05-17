SUBROUTINE REDO.VISA.STLMT.RJ.05TO37.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*  DATE            WHO          REFERENCE          DESCRIPTION
* 22-11-2010     H Ganesh  ODR-2010-08-0469    INITIAL CREATION
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID' ; ID.N = '15'
    ID.T = 'A'


    fieldName='PROCESS.DATE'
    fieldLength='8'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TRANSACTION.CODE'
    fieldLength='2'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TXN.CODE.QUALIFIER'
    fieldLength='1'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TXN.COMP.SEQ.1'
    fieldLength='1'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ACCOUNT.NUMBER'
    fieldLength='16'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ACCT.NUM.EXT'
    fieldLength='3'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='FLOR.LIM.INDCTR'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CRB.EXCEPTION'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='PTIVE.CRD.HLDR.AUT'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ACQR.REF.NUM'
    fieldLength='23'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ACQR.BUS.ID'
    fieldLength='8'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='PURCHASE.DATE'
    fieldLength='4'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='DEST.AMT'
    fieldLength='12'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='DEST.CCY.CODE'
    fieldLength='3'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='SOURCE.AMT'
    fieldLength='12'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='SRC.CCY.CODE'
    fieldLength='3'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MERCHANT.NAME'
    fieldLength='25'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MERCHANT.CITY'
    fieldLength='13'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MERCH.CONTRY.CDE'
    fieldLength='3'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MERCH.CATEG.CDE'
    fieldLength='4'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MERCH.ZIP.CDE'
    fieldLength='5'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MERCH.STATE'
    fieldLength='3'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='REQ.PYMT.SERV'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='VISA.RESERVED'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='USAGE.CODE'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='REASON.CODE'
    fieldLength='2'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='STLMT.FLAG'
    fieldLength='1'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='AUTH.CHAR.IND'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='AUTH.CODE'
    fieldLength='6'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='POS.TERM.CAP'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='INTRNATNL.FEE.IND'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CARD.ID.MTHD'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='COLLECT.ONLYFLAG'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='POS.ENTRY.MODE'
    fieldLength='2'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CENTRL.PROCES.DATE'
    fieldLength='4'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='REIMBURSMNT.ATTRIB'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TRANS.COMP.SEQ.2'
    fieldLength='1'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ISSUER.WRKST.BIN'
    fieldLength='6'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ACQUIRER.WRKST.BIN'
    fieldLength='6'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CHARGEBACK.REF.NO'
    fieldLength='6'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='DOCUMENT.INDICATOR'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MEMBER.MESSAGE.TXT'
    fieldLength='50'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='SPCL.COND.INDCTR'
    fieldLength='2'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='FEE.PRGM.INDCTR'
    fieldLength='3'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ISSUER.CHARGE'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='RESERVED'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CARD.ACCEPTOR.ID'
    fieldLength='15'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TERMINAL.ID'
    fieldLength='8'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='NATIONAL.REIMB.FEE'
    fieldLength='12'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MAIL.PHN.ETRNC.COM'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='SPL.CHRGBCK.INDCTR'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='INTERFACE.TRACE.NO'
    fieldLength='6'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='UNATTND.ACCPT.TRML'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='PREPAID.CARD.INDTR'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='SRVC.DEVLPMNT.FLD'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='AVS.RESP.CODE'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='AUTHORIZE.SRC.CODE'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='PURCHAS.IDNTFR.FMT'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ACCOUNT.SELECTION'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='INSTLMNT.PYMNT.CNT'
    fieldLength='2'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='PURCHAS.IDENTIFIER'
    fieldLength='25'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CASHBACK'
    fieldLength='9'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CHIP.CONDITION.CDE'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='POS.ENVIRONMENT'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='T24.TRAN.REF'
    fieldLength='10'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='STATUS'
    fieldLength='9'
    fieldType=''
    fieldType<2>='PENDING_SENT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='REJECTION.CODE'
    fieldLength='2'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MAN.AUTO'
    fieldLength='1'
    fieldType=''
    fieldType<2>='M_A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CHARGEBACK.SENT'
    fieldLength='1'
    fieldType=''
    fieldType<2>='Y_N'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='FINAL.STATUS'
    fieldLength='10'
    fieldType=''
    fieldType<2>='SETTLED_CHARGEBACK_REJECTED_DUPLICATE_REVERSED_FRAUD'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='STLMT.REF'
    fieldLength='A'
    fieldType='15'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.OTHER.TCR.LINE'
    fieldLength='168'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addField("RESERVED.20", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.19", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.18", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.17", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.16", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

    CALL Table.addOverrideField

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
