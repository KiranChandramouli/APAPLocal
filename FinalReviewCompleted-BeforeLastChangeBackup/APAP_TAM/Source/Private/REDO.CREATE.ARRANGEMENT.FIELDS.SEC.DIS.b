* @ValidationCode : MjotMTc1OTE2NzYwMzpDcDEyNTI6MTY4NDg0MjA5MzEwMTpJVFNTOi0xOi0xOjM0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 34
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CREATE.ARRANGEMENT.FIELDS.SEC.DIS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine GENERAL ARRANGEMENT FIELDS
* @author MGUDINO@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*  DATE              WHO                       Modification
* 2/6/2011   MGUDINO
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*20-11-2023       Santosh	    Intrface Change comment added	SS rebuild issue REDO.CREATE.ARRANGEMENT- Fixed by Santiago
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes


*** </region>


    GOSUB DEFINE.SECURE
    GOSUB INS.DETAIL
    GOSUB DEFINE.DISBURSEMENT
    GOSUB DEFINE.LIMIT
    GOSUB DEFINE.COLLRIGHT
    GOSUB SETAUDIT

RETURN
*----------------------
DEFINE.SECURE:
*----------------------
*    neighbour = '' ;*SS issue fixed by Santiago
    fieldName = 'XX<POLICY.NUMBER'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*
    fieldName = 'XX-POLICY.NUMBER.AUX'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-SEN.POLICY.NUMBER'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = 'XX-INS.POLICY.TYPE'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("APAP.H.INSURANCE.POLICY.TYPE")
*
    fieldName = 'XX-CLASS.POLICY'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("APAP.H.INSURANCE.CLASS.POLICY")
*

    fieldName = 'XX-INS.COMPANY'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.APAP.H.COMP.NAME")
*

    fieldName = 'XX-CUSTOMER.POL'
    fieldLength = '10'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")
*

    fieldName = 'XX-INS.OTHER.PARTY'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")
*
    fieldName = 'XX-CURRENCY'
    fieldLength = '3'
    fieldType = 'CCY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")

*
    CALL Table.addOptionsField("XX-INS.MANAGEM.TYPE","INCLUIR EN CUOTA_NO INCLUIR EN CUOTA","","")
RETURN
*-----------
INS.DETAIL:
*-------------
    fieldName = 'XX-XX<INS.AMOUNT'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-XX>DATE.AMT.SEC'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-XX<INS.MON.POL.AMT'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
* JP20110712 se Modifica la estructura de datos
*---------------------------------
    fieldName = 'XX-XX-INS.PRI.PROPER'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("AA.PROPERTY")


    fieldName = 'XX-XX-INS.EXTRA.AMT'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field


    fieldName = 'XX-XX-INS.XPRI.PROPER'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("AA.PROPERTY")

*

    fieldName = 'XX-XX-INS.TOT.PREM.AMT'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-XX-INS.PAY.TYPE'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("AA.PAYMENT.TYPE")
*--------------------------------


    fieldName = 'XX-XX-INS.DATE.BEG.CHARG'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-XX>INS.DATE.END.CHARG'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-INS.TOTAL.PREM.AMT'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-INS.POLI.ORG.DATE'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-INS.POL.START.DATE'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-INS.POL.EXP.DATE'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-INS.REMARKS'
    fieldLength = '300'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-XX<INS.SEC.COM.TYPE'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("AA.PROPERTY")

*

    fieldName = 'XX-XX-INS.SEC.COM.AMT'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    CALL Table.addOptionsField("XX-XX-TAX.MANAGEM.TYPE","INCLUIR EN CUOTA_NO INCLUIR EN CUOTA","","")
*

    fieldName = 'XX-XX-DATE.BEG.CHARG'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX>XX>DATE.END.CHARG'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
DEFINE.DISBURSEMENT:
*----------------------

    fieldName = 'DIS.AMT.TOT'
    fieldLength = '19.1'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX<DIS.TYPE'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.FC.FORM.DISB")
*

    fieldName = 'XX-XX<ID.DET.INS'
    fieldLength = '4'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-XX-FIELD.DET.INS'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-XX>VAL.DET.INS'
    fieldLength = '80'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-DIS.AMT'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-DIS.STA'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX>DIS.CODTXN'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field


    fieldName = 'XX<CHARG.DISC'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("AA.PROPERTY")
*

    fieldName = 'XX>CHARG.AMOUNT'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN
*----------------------
DEFINE.LIMIT:
*----------------------

    fieldName = 'ID.LIMIT'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*

    fieldName = 'LIMIT.CURRENCY'
*   fieldLength = '3.1'
    fieldLength = '3'
    fieldType = 'CCY'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")
*

    fieldName = 'APPROVAL.DATE'
    fieldLength = '10'
    fieldType = 'D'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'OFFERED.UNTIL'
    fieldLength = '10'
    fieldType = 'D'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'EXPIRY.DATE'
    fieldLength = '10'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'NOTES'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'INTERNAL.AMOUNT'
    fieldLength = '14'
    fieldType ='AMT'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'MAXIMUM.TOTAL'
    fieldLength = '14'
    fieldType = 'AMT'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'AVAILABLE.MARKER'
    fieldLength = '3'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'COLLATERAL.CODE'
    fieldLength = '3'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'MAXIMUM.SECURED'
    fieldLength = '14'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'REVIEW.FREQUENCY'
    fieldLength = '10'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'PROPO.SAL.DATE'
    fieldLength = '10'
    fieldType = 'D'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'ONLINE.LIMIT.DATE'
    fieldLength = '10'
    fieldType = 'D'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'FIXED.VARIABLE'
    fieldLength = '10'
    fieldType = 'A'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
RETURN
*------------------------------------------------------------------------------------------------------------------
DEFINE.COLLRIGHT:
*----------------------

    fieldName = 'XX<ID.COLLATERL.RIGHT'
    fieldLength = '10'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-COLL.RIGHT.CODE'
    fieldLength = '3'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL.CODE")
*
    fieldName = 'XX-XX.LIMIT.REFERENCE'
    fieldLength = '32'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*
    fieldName = 'XX-VALIDITY.DATE'
    fieldLength= '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX>SEC.HOLD.IDENTIF'
    fieldLength = '10'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")
*
RETURN
*------------------------------------------------------------------------------------------------------------------
SETAUDIT:
*----------------------

    fieldName = 'STATUS.DISB'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*neighbour = ''
*fieldName = 'STATUS.TEMPLATE'
*fieldLength = '35'
*fieldType = 'A'
*fieldType<3> = 'NOINPUT'
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Table.addOptionsField("STATUS.TEMPLATE","OK_FAIL_INPROGRESS","","")

    CALL Table.addField("ORIG.FUNDS", T24_String, '', '')     ;* Add a Description Field
    CALL Field.setCheckFile("REDO.FC.ORIG.FUNDS")

    fieldName = 'CHK.AA.ID'
    fieldLength = '2'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = 'LN.CREATION.STATUS'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName = 'XX.LN.CREATION.ERROR'
    fieldLength = '80'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

* CALL Table.addReservedField('RESERVED.20')
*    CALL Table.addReservedField('RESERVED.19')
    CALL Table.addReservedField('RESERVED.16')
    CALL Table.addReservedField('RESERVED.15')
    CALL Table.addReservedField('RESERVED.14')
    CALL Table.addReservedField('RESERVED.13')
    CALL Table.addReservedField('RESERVED.12')
    CALL Table.addReservedField('RESERVED.11')
    CALL Table.addReservedField('RESERVED.10')
    CALL Table.addReservedField('RESERVED.9')
    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

*    CALL Table.addLocalReferenceField('XX.LOCAL.REF') SJ fixing issue "Application cannot use neighbor field feature" in rebuild SS
    CALL Table.addLocalReferenceField('')
    
    CALL Table.addOverrideField
*
*----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information

RETURN
*----------------------------------------------------------------------------

END
