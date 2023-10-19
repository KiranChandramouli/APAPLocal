* @ValidationCode : MjoxNzU3NjY2OTU3OkNwMTI1MjoxNjk2NTkzODUwNjcxOjMzM3N1Oi0xOi0xOjA6MDp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Oct 2023 17:34:10
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
$PACKAGE APAP.REDOAPAP
*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.RE.CRF.NWGL.FIELDS

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 07/12/22 - JAYASURYA
*            New Template changes
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*06/10/2023      Conversion tool            R22 Auto Conversion             Nochange
*06/10/2023      Suresh                     R22 Manual Conversion           Nochange
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)  ;* Define Table id
    ID.N = '100'; ID.T = 'A'
*-----------------------------------------------------------------------------
*CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
*CALL Field.setCheckFile(fileName)        ;* Use DEFAULT.ENRICH from SS or just field 1
    CALL Table.addFieldDefinition("CURRENCY","35","A","")   ;* Add a new field
    CALL Table.addFieldDefinition("DESC.1","35","A","")     ;* Add a new field
    CALL Table.addFieldDefinition("DESC.2","35","A","")     ;* Add a new field
    CALL Table.addFieldDefinition("DESC.3","35","A","")     ;* Add a new fiel
    CALL Table.addFieldDefinition("SECTOR","35","A","")     ;* Add a new field
    CALL Table.addFieldDefinition("LOCAL.BALANCE","35","A","")        ;* Add a new field
    CALL Table.addFieldDefinition("FOREIGN.BALANCE","35","A","")      ;* Add a new field
    CALL Table.addFieldDefinition("MATURITY.DATE","35","A","")        ;* Add a new field
    CALL Table.addFieldDefinition("SCHED.LOCAL.BAL","35","A","")      ;* Add a new field
    CALL Table.addFieldDefinition("SCHED.FCY.BAL","35","A","")        ;* Add a new field
    CALL Table.addFieldDefinition("CONSOL.KEY","35","A","") ;* Add a new field
    CALL Table.addFieldDefinition("CUSTOMER.NO","35","A","")          ;* Add a new field
    CALL Table.addFieldDefinition("DEAL.BALANCE","35","A","")         ;* Add a new field
    CALL Table.addFieldDefinition("DEAL.LCY.BALANCE","35","A","")     ;* Add a new field
    CALL Table.addFieldDefinition("DEAL.RATE","35","A","")  ;* Add a new field
    CALL Table.addFieldDefinition("DEAL.VALUE.DATE","35","A","")      ;* Add a new field
    CALL Table.addFieldDefinition("DEAL.MAT.DATE","35","A","")        ;* Add a new field
    CALL Table.addFieldDefinition("DEAL.MAT.PERIOD","35","A","")      ;* Add a new field
    CALL Table.addFieldDefinition("DEAL.REMAINING.DAYS","35","A","")  ;* Add a new field
    CALL Table.addFieldDefinition("INT.RATE.BASIS","35","A","")       ;* Add a new field
    CALL Table.addFieldDefinition("LINE.TOTAL","35","A","") ;* Add a new field
    CALL Table.addFieldDefinition("DEBIT.MVMT","35","A","") ;* Add a new field
    CALL Table.addFieldDefinition("DEBIT.LCY.MVMT","35","A","")       ;* Add a new field
    CALL Table.addFieldDefinition("CREDIT.MVMT","35","A","")          ;* Add a new field
    CALL Table.addFieldDefinition("CREDIT.LCY.MVMT","35","A","")      ;* Add a new field


*CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour) ;* Specify Lookup values
*CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
