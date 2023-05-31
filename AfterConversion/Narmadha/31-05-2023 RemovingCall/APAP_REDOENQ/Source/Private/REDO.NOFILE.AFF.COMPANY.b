* @ValidationCode : MjotMzY1OTgzMzg6Q3AxMjUyOjE2ODIwNzMzODQwNTE6SVRTUzotMTotMToyOTM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 293
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.AFF.COMPANY(Y.FINAL.OUT)
*---------------------------------------------------------------------
*Description: This routine is for nofile enquiry to display the aff comp based on selected campaign type.
*---------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 17-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*---------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CAMPAIGN.TYPES

    GOSUB PROCESS

RETURN
*-------------------------------------
PROCESS:
*-------------------------------------

    Y.ID.CAMP.TYPE = ''
    Y.FINAL.OUT = ''

    FN.REDO.CAMPAIGN.TYPES = 'F.REDO.CAMPAIGN.TYPES'
    F.REDO.CAMPAIGN.TYPES = ''
    CALL OPF(FN.REDO.CAMPAIGN.TYPES,F.REDO.CAMPAIGN.TYPES)

    FN.REDO.AFFILIATED.COMPANY = 'F.REDO.AFFILIATED.COMPANY'
    F.REDO.AFFILIATED.COMPANY = ''
    CALL OPF(FN.REDO.AFFILIATED.COMPANY,F.REDO.AFFILIATED.COMPANY)


    LOCATE '@ID' IN D.FIELDS<1> SETTING POS1 THEN
        Y.ID.CAMP.TYPE = D.RANGE.AND.VALUE<POS1>
    END

    IF Y.ID.CAMP.TYPE THEN
        CALL F.READ(FN.REDO.CAMPAIGN.TYPES,Y.ID.CAMP.TYPE,R.REDO.CAMPAIGN.TYPES,F.REDO.CAMPAIGN.TYPES,CAMP.ERR)
        Y.FINAL.OUT = R.REDO.CAMPAIGN.TYPES<CG.TYP.ASSOC.AFF.COMP>

    END

    IF Y.FINAL.OUT ELSE
        SEL.CMD = 'SELECT ':FN.REDO.AFFILIATED.COMPANY
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
        Y.FINAL.OUT = SEL.LIST
        CHANGE @FM TO @VM IN Y.FINAL.OUT
    END

RETURN
END
