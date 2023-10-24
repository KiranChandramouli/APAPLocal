* @ValidationCode : MjoxNTA4NDk2MDAyOkNwMTI1MjoxNjg0MjIyODMyNjU0OklUU1M6LTE6LTE6OTc5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 979
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   ++ to +=
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.LATAM.CARD.RELEASE.PROCESS
*-----------------------------------------------------------------------------
*** Simple AUTHORISE template
* @author youremail@temenos.com
* @stereotype subroutine
* @package infra.eb
*!

*** <region name= PROGRAM DESCRIPTION>
*** <desc>Program description</desc>
*-----------------------------------------------------------------------------
* Program Description
*** </region>

*** <region name= MODIFICATION HISTORY>
*** <desc>Modification history</desc>
*-----------------------------------------------------------------------------
* Modification History:
*-----------------------------------------------------------------------------
*** </region>

*** <region name= INSERTS>
*** <desc>Inserts</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.NO.LOCK
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_F.REDO.LATAM.CARD.RELEASE

*** </region>
*-----------------------------------------------------------------------------

*** <region name= MAIN PROCESS LOGIC>
*** <desc>Main process logic</desc>


    GOSUB INITIALISE
    GOSUB PROCESS
    CALL F.WRITE(FN.REDO.CARD.NO.LOCK,ID.NEW,R.REDO.CARD.NO.LOCK)
    CALL F.WRITE(FN.REDO.CARD.NUMBERS,ID.NEW,R.REDO.CARD.NUMBERS)
RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
*** <desc>Process</desc>
PROCESS:
    IDS.LIST=R.NEW(CRD.REL.CARD.NUMBER)
    CNT.LOOP=0
    LOOP

        REMOVE ID.CARD FROM IDS.LIST SETTING CRD.POS

    WHILE ID.CARD:CRD.POS
        CNT.LOOP += 1 ;*R22 AUTO CODE CONVERSION


        LOCATE ID.CARD IN R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER,1> SETTING POS.LOCK THEN

            CALL F.READ(FN.LATAM.CARD.ORDER,ID.CARD,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,ERR)
            IF NOT(R.LATAM.CARD.ORDER) THEN
                CALL F.READ(FN.LATAM.CARD.ORDER.NAU,ID.CARD,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER.NAU,ERR)
            END
            IF R.LATAM.CARD.ORDER THEN

                AF=CRD.REL.CARD.NUMBER
                AV=CNT.LOOP
                ETEXT='ST-CARD.ALREADY.RELATED'
                CALL STORE.END.ERROR
            END  ELSE

                LOCATE ID.CARD IN R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,1> SETTING CRD.POS THEN
                    R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,CRD.POS>='AVAILABLE'
                    DEL R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER,POS.LOCK>
                END
            END

        END ELSE

            AF=CRD.REL.CARD.NUMBER
            AV=CNT.LOOP
            ETEXT='ST-CARD.NOT.IN.LOCK'
            CALL STORE.END.ERROR

        END

    REPEAT

    CRD.AVAIL=R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER,1>
    IF CRD.AVAIL EQ '' THEN
        LOCATE "AVAILABLE" IN R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,1> SETTING AVL.POS THEN
*           INS R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,AVL.POS> IN R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER,1>
            R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER,1>=R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,AVL.POS>
        END


        RETURN
    END

    LOCATE CRD.AVAIL IN R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,1> SETTING POS.CARD THEN

        STATUS.CRD=R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,POS.CARD>
        IF STATUS.CRD NE 'AVAILABLE' THEN
            LOCATE "AVAILABLE" IN R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,1> SETTING AVL.POS THEN
                INS R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,AVL.POS> BEFORE R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER,1>
            END
        END

    END


RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
*** <desc>Initialise</desc>
INITIALISE:

    FN.REDO.CARD.NO.LOCK='F.REDO.CARD.NO.LOCK'
    F.REDO.CARD.NO.LOCK=''
    CALL OPF(FN.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK)

    FN.REDO.CARD.NUMBERS='F.REDO.CARD.NUMBERS'
    F.F.REDO.CARD.NUMBERS=''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

    F.LATAM.CARD.ORDER=''
    FN.LATAM.CARD.ORDER='F.LATAM.CARD.ORDER'

    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

    FN.LATAM.CARD.ORDER.NAU='F.LATAM.CARD.ORDER$NAU'
    F.LATAM.CARD.ORDER.NAU=''

    CALL OPF(FN.LATAM.CARD.ORDER.NAU,F.LATAM.CARD.ORDER.NAU)

    CALL F.READU(FN.REDO.CARD.NO.LOCK,ID.NEW,R.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK,ERR.LOCK,"P")

    CALL F.READU(FN.REDO.CARD.NUMBERS,ID.NEW,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,CRD.NUM.ERR,"P")


RETURN
*** </region>
END
