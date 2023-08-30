* @ValidationCode : Mjo3MTEzMzk4MjE6Q3AxMjUyOjE2ODA3NzcyODM2MjU6MzMzc3U6LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:04:43
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
SUBROUTINE REDO.FRONT.COMPLAINTS.FIELDS
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This Input routine is used to validate if the charge acquired
* from the account holds sufficient balance
*
*----------------------------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRABHU N
* PROGRAM NAME : REDO.FRONT.COMPLAINTS
*----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
*01-MAR-2010        PRABHU             HD1100464        Template added to support ID modification
*11-MAY-2011        PRADEEP S          PACS00060849     Char /type for Claim.Description & Remark fields changed to TEXT
*                                                       All the fields are made as non-mandatory
*                                                       HOT.FIELD property removed for all fields
*                                                       Used the Reserved Field #20 for OBSERVATIONS
*                                                       Vetting value changed from INTERACCION to QUESJAS for the field TYPE
*07-09-2011       MANJU               PACS00104863      virtual table for STATUS FIELD.
* ---------------------------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE

*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '35'
    ID.T = 'A'   ;
*------------------------------------------------------------------------------
    fieldName='CUSTOMER.CODE'
    fieldLength='35'
    fieldType='CUS'
*fieldType<9>='HOT.FIELD'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CUSTOMER")

    fieldName='ACCOUNT.ID'
    fieldLength='18'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("ACCOUNT")

    fieldName='CURRENCY'
    fieldLength='3'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CURRENCY")

    fieldName='PRODUCT.TYPE'
    fieldLength='50'
    fieldType=''
*fieldType<2>=' _SOLICITUD.DE.INFORMACION_SOLICITUD.DE.PRODUCTOS_SOLICITUD.DE.SERVICIOS'
*fieldType<9>='HOT.FIELD'
    neighbour=''
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='CO.PRODUCT.TYPE'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName='OPENING.CHANNEL'
    fieldLength='20'
    fieldType=''
* fieldType<2>='BRANCH_CONTACT.CENTRE_APAENLINEA'
    neighbour=''
* CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='OPENING.CHANNEL'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName='OPENING.DATE'
    fieldLength='8'
    fieldType='D'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='RECEPTION.TIME'
    fieldLength='20'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'PAYROLL'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'COMPANY.PAYROLL'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='AUTHORISATION.NO'
    fieldLength='10'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='BUSINESS.NAME'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TYPE'
    fieldLength='50'
    fieldType=''
    fieldType<2>='RECLAMACION_SOLICITUD_QUEJAS'
*fieldType<2>='RECLAMACION_SOLICITUD_INTERACCION'
*fieldType<9>='HOT.FIELD'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'SLA.ID'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CLAIM.TYPE'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'DISTRIB.CHANNEL'
    fieldLength  = '35'
    fieldType    = ''
* fieldType<2> = ' _E BANKING_Cajeros Automaticos (ATM)_Interactive Voice Response(IVR)_Ventanilla_Proceso Interno Automatizado_Proceso Interno por Error Manual_Punto de Servicio Movil_ACH'
    neighbour    = ''
*  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='DISTRIB.CHANNEL'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)


    fieldName = 'RISK.LEVEL'
    fieldLength = '6'
    fieldType = 'A'
    neighbour = ''
* CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='RISK.LEVEL'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName = 'LEGAL.REP'
    fieldLength = '30'
    fieldType = ''
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ALTERNATE.ID'
    fieldLength='26'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='APPLICATION.ID'
    fieldLength='26'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TRANSACTION.ID'
    fieldLength='50'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'CHARGE.KEY'
    fieldLength = '16'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("FT.COMMISSION.TYPE")

    fieldName='TRANSACTION.AMOUNT'
    fieldLength='26'
    fieldType='AMT'
    fieldType<2,2>='3'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'AMOUNT.CLAIM'
    fieldLength = '26'
    fieldType = 'AMT'
    fieldType<2,2>='3'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TRANSACTION.DATE'
    fieldLength='8'
    fieldType='D'
*fieldType<9>='HOT.FIELD'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'DATE.RESOLUTION'
    fieldLength = '8'
    fieldType = 'D'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'SUPPORT.GROUP'
    fieldLength = '50'
    fieldType = 'A'
    neighbour = ''
*  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*  CALL Field.setCheckFile("PW.PARTICIPANT")
    virtualTableName='SUPPORT.GROUP'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName = 'RATE.TXN.DATE'
    fieldLength = '8'
    fieldType = 'D'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='STATUS'
    fieldLength='50'
    fieldType=''
    fieldType<2> = ' _OPEN_IN PROCESS_RESOLVED_RESOLVED NOTIFIED_CLOSED'
*fieldType<3> = 'NOINPUT'
    neighbour=''
*PACS00104863 - S
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='CM.STATUS'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName='SER.AGR.PERF'
    fieldLength='50'
    fieldType=''
*fieldType<2> = ' _OPEN_IN PROCESS_RESOLVED_RESOLVED NOTIFIED_CLOSED'
*fieldType<9> = 'HOT.FIELD'
    neighbour=''
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='CM.STATUS'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
*PACS00104863-E

    fieldName='DATE.NOTIFICATION'
    fieldLength='8'
    fieldType='D'
    fieldType<3> = 'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'SER.AGR.COMP'
    fieldLength = '50'
    fieldType = ''
*  fieldType<2> = 'EXPIRED_ON TIME'
*  fieldType<3> = 'NOINPUT'
    neighbour = ''
*  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='SER.AGR.COMP'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName = 'CLAIM.DESCRIP'
    fieldLength = '50'
    fieldType = 'TEXT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CLOSING.STATUS'
    fieldLength='50'
    fieldType=''
*PACS00104863 -S
* fieldType<2> = ' _ACCEPTED_REJECTED_VOID_BY PENDING DOCUMENTATION_REJECTED BY CUSTOMER'
    neighbour=''
*   CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    virtualTableName='CL.CLOSING.STATUS'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
*PACS00104863 -E

    fieldName='CLOSING.REMARKS'
    fieldLength='50'
    fieldType='TEXT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX<INTERNAL.REMARKS'
    fieldLength = '50'
    fieldType = 'TEXT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>USER.REMARKS'
    fieldLength = '25'
    fieldType = 'TEXT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='COST.CENTRE'
    fieldLength='20'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='AUTHORISED.BY'
    fieldLength='20'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CLIENT.CONTACTED'
    fieldLength = '3'
    fieldType = ''
    fieldType<2> = 'YES_NO'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.NOTES'
    fieldLength = '50'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CLOSING.DATE'
    fieldLength='8'
    fieldType='D'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CLOSE.NOTIFICATION'
    fieldLength='3'
    fieldType=''
    fieldType<2>='YES_NO'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='CUST.ID.NUMBER'
    fieldLength='20'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'GIVEN.NAMES'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FAMILY.NAMES'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'SOCIAL.NAME'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.RESIDENCE.TYPE'
    fieldLength = '10'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'RESIDENCE'
    fieldLength = '26'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName = 'TOWN.COUNTRY'
    fieldLength = '26'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'COUNTRY'
    fieldLength = '20'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='L.CU.RES.SECTOR'
    fieldLength='35'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.SECTOR.DOMI")

    fieldName = 'L.CU.URB.ENS.REC'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='STREET'
    fieldLength='35'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.ADDRESS'
    fieldLength='35'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.OFF.PHONE'
    fieldLength='35'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='POST.CODE'
    fieldLength='10'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX<L.CU.TEL.TYPE'
    fieldLength='35'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-L.CU.TEL.AREA'
    fieldLength='35'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX-L.CU.TEL.NO'
    fieldLength = '35'
    fieldType = ''
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX-L.CU.TEL.EXT'
    fieldLength = '35'
    fieldType = ''
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX>L.CU.TEL.P.CONT'
    fieldLength='35'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.EMAIL'
    fieldLength='35'
    fieldType='A'
    fieldType<3>='NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'BRANCH'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ACCOUNT.OFFICER'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='DATA.CONFIRMED'
    fieldLength='3'
    fieldType=''
    fieldType<2>='YES_NO'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*PACS00060849 - S
    fieldName = 'OBSERVATIONS'
    fieldLength = '50'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*PACS00060849 - E

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

    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
