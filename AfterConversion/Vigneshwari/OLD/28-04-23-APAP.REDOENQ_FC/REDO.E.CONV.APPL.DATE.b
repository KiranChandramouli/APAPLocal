* @ValidationCode : Mjo3OTczNDI1MjpDcDEyNTI6MTY4MjA3MzM4Mjk3ODpJVFNTOi0xOi0xOjM3NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 376
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.APPL.DATE

*******************************************************************************
*Modification Details:
*=====================
*      Date          Who             Reference               Description
*     ------         -----           -------------           -------------
*    23 SEP 2010   MD Preethi       0DR-2010-03-131          Initial Creation
*
* 17-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*******************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STANDING.ORDER

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
***************************************************************************************************************************
*Description: This conversion routine is used to fetch the current frequency date from STO file with curr.no is equal to 1
***************************************************************************************************************************
**********
OPENFILES:
**********
    FN.STO='F.STANDING.ORDER'
    F.STO=''
    FN.STOHIS='F.STANDING.ORDER$HIS'
    F.STOHIS=''
    CALL OPF(FN.STO,F.STO)
    CALL OPF(FN.STOHIS,F.STOHIS)
RETURN

********
PROCESS:
********
    Y.STO.ID=O.DATA
    CALL F.READ(FN.STO,Y.STO.ID,R.STO,F.STO,Y.ERR)
    Y.STO.CURR.NO = R.STO<STO.CURR.NO>
    IF Y.STO.CURR.NO EQ '1' THEN
        GOSUB APPL.DATE
    END ELSE
        IF Y.STO.CURR.NO NE '1' THEN
            Y.STO.ID=Y.STO.ID:";1"
            CALL F.READ(FN.STO.HIS,Y.STO.ID,R.STO,F.STOHIS,Y.ERR)
            GOSUB APPL.DATE
        END
    END
RETURN
**********
APPL.DATE:
**********
    Y.APPL.DATE=R.STO<STO.CURRENT.FREQUENCY>
    O.DATA=Y.APPL.DATE
RETURN
END
