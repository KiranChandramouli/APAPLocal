* @ValidationCode : MjotMTY1NTEyNjA5MTpVVEYtODoxNjg5NzQ5NjU2MTM0OklUU1M6LTE6LTE6MTkzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:16
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 193
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PCI.RTN
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,CONVERT to CHANGE,++ to +=1,FM to @FM
* 14-07-2023    Narmadha V             R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto Conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ENQUIRY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.APAP.PARAM.DB.CR.MASK ;* R22 Auto Conversion - END

    FN.APAP.PARAM.DB.CR.MASK = "F.APAP.PARAM.DB.CR.MASK"
    F.APAP.PARAM.DB.CR.MASK = ""
    CALL OPF(FN.APAP.PARAM.DB.CR.MASK,F.APAP.PARAM.DB.CR.MASK)

    Y.CARD.VALUE = O.DATA

    Y.CARD.TYPE = NUM(Y.CARD.VALUE[1,4])

    Y.CARD.AUTH = FIELD(Y.CARD.VALUE,".",2,1)

    Y.CARD.LEN = LEN(O.DATA)
    IF Y.CARD.TYPE "1" THEN   ;*Card number startes with number
        Y.CARD.NUM = O.DATA[1,16]
        GOSUB MASK.CARD.NUM
        O.DATA = Y.MASK.CARD.NUM

        IF Y.CARD.LEN GT 16 THEN

            O.DATA = Y.MASK.CARD.NUM : '.' : Y.CARD.AUTH

        END ELSE

            O.DATA = Y.MASK.CARD.NUM

        END

    END ELSE        ;*Card number starts with its Type
        Y.CARD.TYPE = O.DATA[1,5]
        Y.CARD.NUM = O.DATA[6,LEN(O.DATA)]
        GOSUB MASK.CARD.NUM
        O.DATA = Y.CARD.TYPE:Y.MASK.CARD.NUM
    END

RETURN

MASK.CARD.NUM:

    Y.INT = 1
    Y.LEN.CARD = LEN(Y.CARD.NUM)

    Y.CARD.NUM = FIELD(Y.CARD.NUM,".",1,1)

*    CALL F.READ(FN.APAP.PARAM.DB.CR.MASK,"L.APAP.TD.PEND.LIQ",R.MASK.PARAM,F.APAP.PARAM.DB.CR.MASK,ERR.MASK.PARAM)
IDVAR.1 = "L.APAP.TD.PEND.LIQ" ;* R22 UTILITY AUTO CONVERSION
    CALL F.READ(FN.APAP.PARAM.DB.CR.MASK,IDVAR.1,R.MASK.PARAM,F.APAP.PARAM.DB.CR.MASK,ERR.MASK.PARAM);* R22 UTILITY AUTO CONVERSION
    IF R.MASK.PARAM THEN
        Y.PARAM.DIGIT = R.MASK.PARAM<APAP.MASK.MASKING.DIGITS>
        CHANGE " " TO @FM IN Y.PARAM.DIGIT
        LOOP
        WHILE Y.INT LE Y.LEN.CARD
            Y.QUO = Y.INT/4
            Y.QUO.DEC = FIELD(Y.QUO,".",2,1)
            LOCATE Y.INT IN Y.PARAM.DIGIT SETTING Y.DIGI.POS THEN
                IF (Y.QUO.DEC NE "") OR (Y.INT EQ Y.LEN.CARD) THEN
                    Y.MASK.CARD.NUM := "*"
                END ELSE
                    Y.MASK.CARD.NUM := "*-"
                END
            END ELSE
                IF (Y.QUO.DEC NE "") OR (Y.INT EQ Y.LEN.CARD) THEN
                    Y.MASK.CARD.NUM := Y.CARD.NUM[Y.INT,1]
                END ELSE
                    Y.MASK.CARD.NUM := Y.CARD.NUM[Y.INT,1]:"-"
                END
            END
            Y.INT += 1
        REPEAT
    END

RETURN

END
