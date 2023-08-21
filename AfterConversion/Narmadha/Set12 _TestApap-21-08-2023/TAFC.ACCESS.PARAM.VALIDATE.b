* @ValidationCode : MjotMTg1NDI5NzU2MTpVVEYtODoxNjkyNjA0NTU4NTAzOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Aug 2023 13:25:58
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
$PACKAGE APAP.TESTAPAP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TAFC.ACCESS.PARAM.VALIDATE
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History :
* DATE          WHO            REFERENCE               DESCRIPTION
* 21 AUG 2023   Narmadha V     Manual R22 Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PGM.FILE
    $INSERT I_F.TAFC.ACCESS.PARAM
    $INSERT I_F.STANDARD.SELECTION
*-----------------------------------------------------------------------------
* For Future Use..... We can Introduce a Validation Routine later.

    GOSUB INITIALISE

    GOSUB MAIN.PROCESS

RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*----------

    APPL.ERR = ''

    FN.PGM.FILE = 'F.PGM.FILE'
    F.PGM.FILE = ''
    CALL OPF(FN.PGM.FILE, F.PGM.FILE)

    SS.REC = ''

RETURN

*-----------------------------------------------------------------------------
MAIN.PROCESS:
*------------


    AF = EB.TAP.SENSITIVE.FILES
    TAP.SEN.FILE.CNT = DCOUNT(R.NEW(AF), @VM)
    FOR AV = 1 TO TAP.SEN.FILE.CNT

        AF = EB.TAP.SENSITIVE.FILES
        IF R.NEW(AF)<1, AV> NE '' AND R.NEW(AF)<1, AV> NE 'ALL' THEN

            TAP.SEN.FILE = R.NEW(AF)<1, AV>
            OPEN TAP.SEN.FILE TO F.TAP.SEN.FILE THEN
                CLOSE F.TAP.SEN.FILE
            END ELSE
                EXECUTE 'ls ':TAP.SEN.FILE CAPTURING LS.OUT
                IF INDEX(LS.OUT, 'not found', 1) THEN
                    ETEXT = 'File does not exist'
                END
            END

            IF ETEXT THEN
                F.TAP.SEN.FILE = 'Actual File does not exist'
                CALL STORE.END.ERROR
            END ELSE
                OPEN 'DICT',TAP.SEN.FILE TO F.TAP.SEN.FILE.DICT ELSE
                    F.TAP.SEN.FILE = 'Actual Dict File does not exist'
                END
            END
        END

        AF = EB.TAP.SENSITIVE.FIELDS
        TAP.SEN.FLD.CNT = DCOUNT(R.NEW(AF)<1, AV>, @SM)
        FOR AS = 1 TO TAP.SEN.FLD.CNT

            TAP.SEN.FLD =  R.NEW(AF)<1, AV, AS>
            IF TAP.SEN.FLD NE '' THEN
                IF NOT(F.TAP.SEN.FILE) THEN
                    READ REC FROM F.TAP.SEN.FILE.DICT, TAP.SEN.FLD ELSE
                        ETEXT = 'Field does not exist'
                        CALL STORE.END.ERROR
                    END
                END ELSE
                    ETEXT = F.TAP.SEN.FILE
                    CALL STORE.END.ERROR
                END
            END
        NEXT AS

        AF = EB.TAP.SENSITIVE.FILES.CMDS

        SEN.CMD.CNT = DCOUNT(R.NEW(AF), @SM)

        FOR AS = 1 TO SEN.CMD.CNT
            TAP.SEN.CMD = R.NEW(AF)<1, AV, AS>
            IF TAP.SEN.CMD NE '' AND NOT(TAP.SEN.CMD MATCHES 'CREATE':@VM:'DELETE':@VM:'CLEAR') THEN
                EXECUTE 'jshow -c ':TAP.SEN.CMD CAPTURING JSHOW.OUT
                IF JSHOW.OUT NE '' AND JSHOW.OUT[':',1,1] NE 'Executable' THEN
                    ETEXT = 'Executable does not exist'
                    CALL STORE.END.ERROR
                END
            END
        NEXT AS
    NEXT AV

    AF = EB.TAP.EXCEPT.FILES
    EXCEPT.FILES.CNT = DCOUNT(R.NEW(AF), @VM)

    FOR AV = 1 TO EXCEPT.FILES.CNT
        AF = EB.TAP.EXCEPT.FILES
        IF R.NEW(AF)<1, AV> NE '' AND R.NEW(AF)<1, AV> NE 'ALL' THEN

            TAP.FILE = R.NEW(AF)<1, AV>
            OPEN TAP.FILE TO F.TAP.FILE THEN
                CLOSE F.TAP.FILE
            END ELSE
                EXECUTE 'ls ':TAP.FILE CAPTURING LS.OUT
                IF INDEX(LS.OUT, 'not found', 1) THEN
                    ETEXT = 'File does not exist'
                END
            END

            IF ETEXT THEN
                F.TAP.FILE = 'Actual File does not exist'
                CALL STORE.END.ERROR
            END

            AF = EB.TAP.EXCEPT.FILES.CMDS

            EXCEPT.CMD.CNT = DCOUNT(R.NEW(AF)<1, AV>, @SM)

            FOR AS = 1 TO EXCEPT.CMD.CNT
                TAP.EXCEPT.CMD = R.NEW(AF)<1, AV, AS>
                IF TAP.EXCEPT.CMD NE '' AND TAP.EXCEPT.CMD MATCHES 'CREATE':@VM:'DELETE':@VM:'CLEAR' THEN
                    EXECUTE 'jshow -c ':TAP.EXCEPT.CMD CAPTURING JSHOW.OUT
                    IF JSHOW.OUT NE '' AND JSHOW.OUT[':',1,1] NE 'Executable' THEN
                        ETEXT = 'Executable does not exist'
                        CALL STORE.END.ERROR
                    END
                END
            NEXT AS
        END
    NEXT AV

    AF = EB.TAP.RESTRICT.CMDS

    REST.CMD.CNT = DCOUNT(R.NEW(AF), @VM)

    FOR AV = 1 TO REST.CMD.CNT
        TAP.REST.CMD = R.NEW(AF)<1, AV>
        IF TAP.REST.CMD NE '' AND TAP.REST.CMD MATCHES 'CREATE':@VM:'DELETE':@VM:'CLEAR' THEN
            EXECUTE 'jshow -c ':TAP.REST.CMD CAPTURING JSHOW.OUT
            IF JSHOW.OUT NE '' AND JSHOW.OUT[':',1,1] NE 'Executable' THEN
                ETEXT = 'Executable does not exist'
                CALL STORE.END.ERROR
            END
        END

    NEXT AV

    AF = EB.TAP.EXCEPT.CMDS

    EXCEPT.CMD.CNT = DCOUNT(R.NEW(AF), @VM)
    FOR AV = 1 TO EXCEPT.CMD.CNT
        TAP.EXCEPT.CMD = R.NEW(AF)<1, AV>
        IF TAP.EXCEPT.CMD NE '' AND NOT(TAP.EXCEPT.CMD MATCHES 'CREATE':@VM:'DELETE':@VM:'CLEAR') THEN
            EXECUTE 'jshow -c ':TAP.EXCEPT.CMD CAPTURING JSHOW.OUT
            IF (JSHOW.OUT NE '' AND JSHOW.OUT[':',1,1] NE 'Executable') THEN    ;*OR NOT(TAP.EXCEPT.CMD['.',DCOUNT(TAP.EXCEPT.CMD, '.'), 1] MATCHES 'sh':@VM:'cmd':@VM:'bat') THEN
                ETEXT = 'Executable does not exist'
                CALL STORE.END.ERROR
            END
        END
    NEXT AV


RETURN

*-----------------------------------------------------------------------------


END
