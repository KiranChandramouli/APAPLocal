* @ValidationCode : MjotOTQ1ODE2NjU6Q3AxMjUyOjE2ODIwNzMzNzk2ODg6SVRTUzotMTotMToyMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.CREATE.DATE

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STANDING.ORDER

    FN.STO='F.STANDING.ORDER'
    FV.STO=''
    CALL OPF(FN.STO,FV.STO)

    STO.ID = CURRENT.DATA<3>
    CALL F.READ(FN.STO,STO.ID,R.STO.REC,FV.STO,STO.ERR)

    IF NOT(STO.ERR) THEN

        DATE.TEMP=R.STO.REC<STO.DATE.TIME>[1,6]
        DATE.B4CHANGE = ICONV(DATE.TEMP,'D')
        DATE.CREATE = OCONV(DATE.B4CHANGE,'D')
        O.DATA=DATE.CREATE
    END
RETURN
END
