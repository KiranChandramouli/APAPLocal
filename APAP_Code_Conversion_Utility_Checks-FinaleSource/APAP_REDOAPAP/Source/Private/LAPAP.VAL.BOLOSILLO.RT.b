* @ValidationCode : MjoxMjg5NDMwNDAzOkNwMTI1MjoxNjg1MDAwMDU0NjA1OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 May 2023 13:04:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*25/05/2023      CONVERSION TOOL           AUTO R22 CODE CONVERSION              T24.BP REMOVED IN INSERTFILE,FM TO @FM
*25/05/2023      HARISH VIKRAM              MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.VAL.BOLOSILLO.RT

    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION -START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.VERSION
    $INSERT I_F.AC.LOCKED.EVENTS ;*AUTO R22 CODE CONVERSION - END


    GOSUB LOAD
    GOSUB SELECT
    GOSUB PROCESS
*====
LOAD:
*====
    Y.ACCOUNT                = COMI
    Y.PARAMETER              = "BOLSILLO"

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
RETURN

*======
SELECT:
*======
    NO.OF.REC = ''; SEL.ERR = ''; Y.COUNT.LIST = ''; LIST.POS = '';
    SEL.CMD = "SELECT ":FN.AC.LOCKED.EVENTS:" WITH ACCOUNT.NUMBER EQ " :Y.ACCOUNT:" AND L.AC.LOCKE.TYPE EQ " :Y.PARAMETER;
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR);
    Y.COUNT.LOCK = DCOUNT(SEL.LIST,@FM);
RETURN

*=======
PROCESS:
*=======
    IF Y.COUNT.LOCK GE 3 THEN
        TEXT = "La cuenta numero: ":Y.ACCOUNT:" ya posee 3 bolsillos asociados"
        ETEXT = TEXT
        E = TEXT
        CALL ERR
    END

RETURN

END
