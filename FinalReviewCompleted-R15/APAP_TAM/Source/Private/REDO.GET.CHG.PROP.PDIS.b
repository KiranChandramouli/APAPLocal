* @ValidationCode : MjotMTkzNDM3MDIyMzpDcDEyNTI6MTY4MDcxNTk4NjA2OTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 23:03:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.CHG.PROP.PDIS(R.DATA)
*-----------------------------------------------------------------------------

* This routine is used to display the properties

* Modification History:

* Marimuthu S          28-Nov-2012             PACS00236823

* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, F TO CACHE
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.PROPERTY


    FN.AA.PROPERTY = 'F.AA.PROPERTY'
    F.AA.PROPERTY = ''
    CALL OPF(FN.AA.PROPERTY,F.AA.PROPERTY)


    LOCATE 'Y.ARR.ID' IN D.FIELDS SETTING POS THEN
        Y.AA.ID = D.RANGE.AND.VALUE<POS>
    END


    Y.PROP.CLS = 'CHARGE'
    Y.RET.PROP = '' ; RET.COND = ''; RET.ERR = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.AA.ID,Y.PROP.CLS,'','',Y.RET.PROP,RET.COND,RET.ERR)

    Y.CNT = DCOUNT(Y.RET.PROP,@FM)
    FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.PROP = Y.RET.PROP<FLG>
        CALL CACHE.READ(FN.AA.PROPERTY, Y.PROP, R.PROP, PROP.ER)       ;** R22 Auto conversion - F TO CACHE
        R.DATA<-1> = Y.PROP:'*':R.PROP<AA.PROP.DESCRIPTION,1>
        Y.CNT -= 1
    REPEAT

RETURN

END
