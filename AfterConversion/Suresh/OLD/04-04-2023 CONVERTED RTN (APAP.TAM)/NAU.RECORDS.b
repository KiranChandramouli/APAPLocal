* @ValidationCode : MjotNDIxNzQ3MzIxOkNwMTI1MjoxNjgwNjA4OTgyMzg1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 17:19:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*04/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION      FM TO @FM, K TO K.VAR, I TO I.WAR
*04/04/2023         SURESH           MANUAL R22 CODE CONVERSION            NOCHANGE
*-----------------------------------------------------------------------------------
PROGRAM NAU.RECORDS

    $INSERT I_COMMON
    $INSERT I_EQUATE

    OPEN "TAM.BP" TO F.TEST THEN
        K.VAR = 1 ;*AUTO R22 CODE CONVERSION
    END

    READ SEL.CMDS FROM F.TEST,"NAU.APPS" THEN
        SEL.CMDS = SORT(SEL.CMDS)
        SEL.CMD.CNT = DCOUNT(SEL.CMDS,@FM) ;*AUTO R22 CODE CONVERSION

        SEL.LIST = ''

        LOOP
            REMOVE SEL.ID FROM SEL.CMDS SETTING POS
        WHILE SEL.ID:POS
            SEL.CMD = 'SELECT ':SEL.ID:'$NAU'
            SEL.TEMP.LIST = ''
            CALL EB.READLIST(SEL.CMD,SEL.TEMP.LIST,'',NR.CNT,'')
            FOR I.VAR = 1 TO NR.CNT ;*AUTO R22 CODE CONVERSION
                SEL.LIST<-1> = SEL.ID:"NAU>>":SEL.TEMP.LIST<I.VAR> ;*AUTO R22 CODE CONVERSION
            NEXT I.VAR ;*AUTO R22 CODE CONVERSION
        REPEAT

        CRT " S T A G E  (1. Before Upgrade / 2. After Upgrade / 3. Final ) : "
        INPUT ANS

        IF ANS EQ '' THEN
            ANS = "TEST"
        END

        WRITE SEL.LIST TO F.TEST, "NAU.RECORDS.":ANS:".UPGRADE" ON ERROR
            CRT "WRITE FAILS"
        END

    END

RETURN
END
