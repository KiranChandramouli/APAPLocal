* @ValidationCode : MjotMTk3OTM3NTYwOkNwMTI1MjoxNjg0ODM2MDQxNDcwOklUU1M6LTE6LTE6LTYzOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -63
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.H.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.H.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.APAP.H.PARAMETER
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------             -------------
* 11th JUN 2010    Mohammed Anies K     ODR-2009-10-1678 B.10     Initial Creation
* 17 NOV 2011      KAVITHA              PACS00164141              PACS00164141  FIX
* 26-Nov-2018      Vignesh Kumaar M R   CI#2795720                BRD001 - FAST FUNDS SERVICES
* Date                  who                   Reference              
* 05-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION FM TO @FM AND $INCLUDE GLOBUS.BP TO $INSERT
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON    ;*R22 AUTO CONVERSTION $INCLUDE GLOBUS.BP TO $INSERT
    $INSERT I_EQUATE    ;*R22 AUTO CONVERSTION $INCLUDE GLOBUS.BP TO $INSERT
    $INSERT I_DataTypes  ;*R22 AUTO CONVERSTION $INCLUDE GLOBUS.BP TO $INSERT
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)        ;* Define Table id
    ID.N = '35'    ; ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'CHQ.RETAIN.MONTHS'
    fieldLength = '35.1'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'INS.TRANS.CODE'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('TELLER.TRANSACTION')

    fieldName = 'EXT.TRANS.CODE'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('TELLER.TRANSACTION')

*PACS00164141  -S
    fieldName = 'DEBT.CARD.TRANS.DR'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('TRANSACTION')

    fieldName = 'DEBT.CARD.TRANS.CR'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('TRANSACTION')
*PACS00164141  -E


    fieldName = 'DEBT.CARD.PL.CATEG'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'XX.INS.CHARGE'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('AA.PROPERTY')


*---------These five fields are attached as a part of C.15---------------------*
    fieldName = 'REGION.CODE'      ;
    fieldLength = '1'     ;
    fieldType=''
    fieldType<2> = '1_2_3'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'CARD.LANGG'      ;
    fieldLength = '1'     ;
    fieldType=''
    fieldType<2> = '1_2'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field


    fieldName = 'DELIMITER'      ;
    fieldLength = '3'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'XX<RESP.CODE.DESB'      ;
    fieldLength = '25'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'XX>RESP.CODE'      ;
    fieldLength = '3'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field


    fieldName = 'APERTA.FILE.NAME'      ;
    fieldLength = '15'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'XX.APERTA.PATH'      ;
    fieldLength = '50'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'XX.CORPORATE.CATEG'      ;
    fieldLength = '30'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field


    fieldName = 'CARD.REQ.DESC'      ;
    fieldLength = '60'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'EXPIRY.DATE.DESC'      ;
    fieldLength = '60'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'CMS.CARD.DESC'      ;
    fieldLength = '60'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'CMS.ACC.DESC'      ;
    fieldLength = '60'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'EXP.REC.DESC'      ;
    fieldLength = '60'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

* Below Fields added as part of B.166B

    fieldName = 'XX<ENQ.NAME'
    fieldLength = '50'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('ENQUIRY')

    fieldName = 'XX>FT.CHARGE.TYPE'
    fieldLength = '20'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('FT.CHARGE.TYPE')

    fieldName = 'LOCK.DAYS'
    fieldLength = '3'     ;
    fieldType=''
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'FTTC.APAP.CR.CARD'
    fieldLength = '4.1'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')

    fieldName = 'FTTC.ATHL.CR.CRD'
    fieldLength = '4.1'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')

    fieldName = 'RESERVERD.FTTC1'
    fieldLength = '4'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')

    fieldName = 'RESERVERD.FTTC2'
    fieldLength = '4'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')

    fieldName = 'RESERVERD.FTTC3'
    fieldLength = '4'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')

    fieldName = 'FTTC.VISAL.CR.CRD'
    fieldLength = '4.1'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')

    fieldName = 'RESERVERD.FTTC4'
    fieldLength = '4'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')

    fieldName = 'RESERVERD.FTTC5'
    fieldLength = '4'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')

    fieldName = 'RESERVERD.FTTC6'
    fieldLength = '4'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')

    fieldName = 'CURRENCY.MARKET'
    fieldLength = '4.1'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('CURRENCY.MARKET')

    fieldName = 'XX<TC.CODE'
    fieldLength = '4.1'     ;
    fieldType='ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field


    fieldName = 'XX-CR.ACCT'
    fieldLength = ''
    fieldType='ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('ACCOUNT')

    fieldName = 'XX-DR.ACCT'
    fieldLength = ''     ;
    fieldType='ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('ACCOUNT')

    fieldName = 'XX-FOR.CR.ACCT'
    fieldLength = ''
    fieldType='ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('ACCOUNT')

    fieldName = 'XX-FOR.DR.ACCT'
    fieldLength = ''     ;
    fieldType='ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('ACCOUNT')

    fieldName = 'XX-MODIFY.RTN'
    fieldLength = '35'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'XX-CR.ACCT.INTERNAL'
    fieldLength = ''     ;
    fieldType='ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('ACCOUNT')

    fieldName = 'XX-FTTC'
    fieldLength = '20'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('FT.CHARGE.TYPE')

    fieldName = 'XX-FT.VERSION'
    fieldLength = '54'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('VERSION')

    fieldName = 'XX>AC.LCK.REV.VERSION'
    fieldLength = '54'     ;
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('VERSION')

    fieldName = 'XX.ATH.TRANS'
    fieldLength = '6'
    fieldType='ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    CALL Table.addLocalReferenceField('XX.LOCAL.REF')

    fieldName = 'XX.REST.REL.CRD'
    fieldLength = '3'
    fieldType=''
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('RELATION')

    fieldName = 'ACQUIRER.PER'
    fieldLength = '10'
    fieldType='R'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field


    fieldName = 'ATM.EXCESS.PER'
    fieldLength = '10'
    fieldType= 'R'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

*PACS00094453-S
    fieldName = 'MAX.CARDS.ALLOW'
    fieldLength = '25'
    fieldType= ''
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
*PACS00094453-E

    fieldName = 'PRINCIPAL.IND'
    fieldLength = '5'
    fieldType= 'ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName = 'ADITIONAL.IND'
    fieldLength = '5'
    fieldType= 'ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addReservedField('RESERVED.7')

    fieldName = 'NULL.VALUE.IND'
    fieldLength = '35'
    fieldType= 'ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* Fix for 2795720 [BRD001 - FAST FUNDS SERVICES]

    fieldName = 'XX<OCT.FF.ACCT'
    fieldLength = '10.1'
    fieldType = "":@FM:"COBRAR_PAGAR_REVPAGAR"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'XX-OCT.DOP.ACCT'
    fieldLength = ''
    fieldType='ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('ACCOUNT')

    fieldName = 'XX>OCT.USD.ACCT'
    fieldLength = ''
    fieldType='ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Field.setCheckFile('ACCOUNT')

* End of Fix

    CALL Table.addReservedField('RESERVED.11')
    CALL Table.addReservedField('RESERVED.12')
    CALL Table.addReservedField('RESERVED.13')
    CALL Table.addReservedField('RESERVED.14')
    CALL Table.addReservedField('RESERVED.15')
    CALL Table.addOverrideField

    CALL Table.setAuditPosition         ;* Poputale audit information

RETURN
*-----------------------------------------------------------------------------
END
