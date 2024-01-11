* @ValidationCode : Mjo0MTQ5MzE5Mjk6VVRGLTg6MTcwMzc0MDY0NTEwMjpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Dec 2023 10:47:25
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
* 28-12-2023      Narmadha V        Manual R22 Conversion      Variable Changed in Call F.READ
******************************************************************************

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
*CALL F.READ(FN.STO.HIS,Y.STO.ID,R.STO,F.STOHIS,Y.ERR)
            CALL F.READ(FN.STOHIS,Y.STO.ID,R.STO,F.STOHIS,Y.ERR) ;*Manual R22 Conversion- Variable Changed in Call F.READ
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
