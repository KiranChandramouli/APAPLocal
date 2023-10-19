* @ValidationCode : MjozODQ3MjY5MjA6Q3AxMjUyOjE2ODI0MTIzNjYyMjI6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.VAULT.ID
*-----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                         = TO EQ
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.TELLER.PARAMETER





INITIALISE:
*----------
*
    F.TELLER.ID = ''
    FN.TELLER.ID = 'F.TELLER.ID'
    CALL OPF(FN.TELLER.ID, F.TELLER.ID)


PROCESS:
*-------
*
    TO.VAULT.ID    = COMI
    IF TO.VAULT.ID EQ '' THEN
        TO.VAULT.ID = R.NEW(TT.TE.NARRATIVE.1)
    END

    IF NOT(NUM(TO.VAULT.ID)) THEN
        ETEXT = "EB-INP.NOT.NUMERIC"
        AF = TT.TE.NARRATIVE.1
        CALL STORE.END.ERROR
    END
*  VNL 2012SEP28 - S
    R.TELLER.ID = "" ; TT.ID.ERR = ""
    CALL F.READ(FN.TELLER.ID, TO.VAULT.ID, R.TELLER.ID, F.TELLER.ID, TT.ID.ERR)
    IF NOT(TT.ID.ERR) THEN
*
        IF NOT(ETEXT) THEN
*        CALL F.READ(FN.TELLER.ID, TO.VAULT.ID, R.TELLER.ID, F.TELLER.ID, TT.ID.ERR)
            IF (R.TELLER.ID<TT.TID.USER>) THEN
                GOSUB GET.ERRTTID     ;*  VNL 2012SEP28 - S/E
            END

        END

        IF NOT(ETEXT) THEN
            W.COMPANY = R.TELLER.ID<TT.TID.CO.CODE>
            IF W.COMPANY EQ ID.COMPANY THEN
                GOSUB GET.ERRTTID     ;*  VNL 2012SEP28 - S/E
            END
        END

        IF NOT(ETEXT) THEN
            CALL CACHE.READ('F.TELLER.PARAMETER', W.COMPANY, R.TT.PARAM, TT.PAR.ERR)

            LOCATE TO.VAULT.ID IN R.TT.PARAM<TT.PAR.VAULT.ID,1> SETTING POS ELSE
                GOSUB GET.ERRTTID     ;*  VNL 2012SEP28 - S/E
            END
            IF POS NE 1 THEN
                GOSUB GET.ERRTTID     ;*  VNL 2012SEP28 - S/E
            END

        END
        IF NOT(ETEXT) THEN
            CR.FIELD = AF
            LOCATE CR.FIELD IN T.FIELDNO<1> SETTING CR.POS THEN
                T.ENRI<CR.POS> = "TESTING"
                COMI.ENRI =  "TESTING"
                OFS$ENRI<CR.POS> = "TESTING"
            END

        END
*
    END
    ELSE
        GOSUB GET.ERRTTID         ;*  VNL 2012SEP28 - S/E
    END
*   VNL 2012SEP28 - E
RETURN


*-----------------------------------------------------------------------------

*** <region name= GET.ERRTTID>
GET.ERRTTID:
***
    ETEXT = "TT-NOT.A.VALID.VAULT"
    AF = TT.TE.NARRATIVE.1
    CALL STORE.END.ERROR
RETURN
*** </region>
END
