* @ValidationCode : MjoxODQwMzE0MDMzOlVURi04OjE3MDM3NDE4OTI3MTM6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Dec 2023 11:08:12
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
SUBROUTINE REDO.E.CONV.INITIAL.DATE
*******************************************************************************
*Modification Details:
*=====================
*      Date          Who             Reference               Description
*     ------         -----           -------------           -------------
*    23 SEP 2010   MD Preethi       0DR-2010-03-131          Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 28-12-2023         Narmadha V               Manual R22 Conversion      Variable Changed in Call F.READ
*******************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STANDING.ORDER

**********************************************************************************************************************
*Description:  REDO.E.CONV.INITIAL.DATE is a conversion routine attached to the ENQUITY>REDO.ENQ.REP.REC.PAY.SER,
*the routine fetches the value from O.DATA reads the STO file and fetches the value from the DATE.TIME field when the
*CURR.NO equal to 1 and return it to O.DATA
*********************************************************************************************************************

    FN.STO='F.STANDING.ORDER'
    F.STO=''
    FN.STOHIS='F.STANDING.ORDER$HIS'
    F.STOHIS=''
    CALL OPF(FN.STO,F.STO)
    CALL OPF(FN.STOHIS,F.STOHIS)
    Y.STO.ID=O.DATA
    CALL F.READ(FN.STO,Y.STO.ID,R.STO,F.STO,Y.ERR)
    Y.STO.CURR.NO =R.STO<STO.CURR.NO>
    IF Y.STO.CURR.NO EQ '1' THEN
        GOSUB INITIAL.DATE
    END ELSE
        IF Y.STO.CURR.NO NE '1' THEN
            Y.STO.ID=Y.STO.ID:";1"
*CALL F.READ(FN.STO.HIS,Y.STO.ID,R.STO,F.STOHIS,Y.ERR)
            CALL F.READ(FN.STOHIS,Y.STO.ID,R.STO,F.STOHIS,Y.ERR) ;*Manual R22 Connversion - Variable Changed in Call F.READ
            GOSUB INITIAL.DATE
        END
    END
INITIAL.DATE:
    Y.DATE.TIME=R.STO<STO.DATE.TIME,1>
    Y.DATE=Y.DATE.TIME[1,6]
    Y.DATE=ICONV(Y.DATE,"DJ")
    Y.DATE=OCONV(Y.DATE,"D4E/")
    O.DATA=Y.DATE
RETURN
END
