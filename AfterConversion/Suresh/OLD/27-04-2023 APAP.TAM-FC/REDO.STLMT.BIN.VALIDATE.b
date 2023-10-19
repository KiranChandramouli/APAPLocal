* @ValidationCode : MjotMTYxODQyMjYwMTpDcDEyNTI6MTY4MTA1NjQ4NjE1NDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:06
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
SUBROUTINE REDO.STLMT.BIN.VALIDATE
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.STLMT.BIN.VALIDATE
*********************************************************
*DESCRIPTION: This routine will validate the BIN for settlement process
* When the BIN is not APAP bin or APAP DEBIT Card bin and wrong card number will throw error


*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.VISA.STLMT.FILE.PROCESS
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*01.12.2010  H GANESH        ODR-2010-08-0469  INITIAL CREATION
*10.04.2023  Conversion Tool       R22         Auto Conversion     - ! TO *
*10.04.2023  Shanmugapriya M       R22         Manual Conversion   - No changes
*
*----------------------------------------------------------------------




    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
*$INCLUDE TAM.BP I_REDO.ATH.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.CARD.BIN



    IF ERROR.MESSAGE NE '' THEN
        RETURN
    END

    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.BIN.NUMBER = Y.FIELD.VALUE[1,6]

    CALL F.READ(FN.REDO.CARD.BIN,Y.BIN.NUMBER,R.REDO.CARD.BIN,F.REDO.CARD.BIN,CARD.BIN.ERR)
*                    ;** R22 Auto conversion - ! TO *
    IF R.REDO.CARD.BIN EQ '' THEN
        ERROR.MESSAGE = "CARD.NUM.DOESNT.EXIST"
        RETURN
    END ELSE
        APAP.BIN = R.REDO.CARD.BIN<REDO.CARD.BIN.BIN.OWNER>
        BIN.TYPE = R.REDO.CARD.BIN<REDO.CARD.BIN.BIN.TYPE>
    END
*              ;** R22 Auto conversion - ! TO *
    IF APAP.BIN EQ 'APAP' AND BIN.TYPE EQ 'CREDIT' THEN
        CONT.FLAG = 'TRUE'
        RETURN
    END
*             ;** R22 Auto conversion - ! TO *
    IF APAP.BIN EQ 'NONAPAP' THEN
        ERROR.MESSAGE = 'CARD.NUM.DOESNT.EXIST'
        RETURN
    END
*               ;** R22 Auto conversion - ! TO *
    IF APAP.BIN EQ 'APAP' AND BIN.TYPE EQ 'DEBIT' THEN
        CARD.TYPE.VAL = R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
    END
*                        ;** R22 Auto conversion - ! TO *
*    changing code to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279

    LOOP
        REMOVE CRD.TYP FROM CARD.TYPE.VAL SETTING POS.CRD
    WHILE CRD.TYP:POS.CRD

        R.LATAM.CARD.ORDER=''
        LCO.ID = CRD.TYP:'.':Y.FIELD.VALUE
        CALL F.READ(FN.LATAM.CARD.ORDER,LCO.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,CARD.ORDER.ERR)

        IF R.LATAM.CARD.ORDER THEN
            CARD.TYPE.VAL=CRD.TYP

            BREAK
        END
    REPEAT
* Updating end multivalue field CARD.TYPE in REDO.CARD.BIN PACS00033279

*            ;** R22 Auto conversion - ! TO *
    IF R.LATAM.CARD.ORDER EQ '' THEN
        CHECK.ADD.DIGIT = 'TRUE'
    END ELSE
        NATIONAL.FLAG = R.REDO.CARD.BIN<REDO.CARD.BIN.NATIONAL.MARK>
    END
*               ;** R22 Auto conversion - ! TO *
RETURN
END
