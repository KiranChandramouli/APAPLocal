* @ValidationCode : MjotNzUwNzc1NDU4OkNwMTI1MjoxNjgyMDczMzgzMTYyOklUU1M6LTE6LTE6NzM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 73
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.LIST.VAULTS(VAULTS.ID.LIST)

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 17-APR-2023     Conversion tool    R22 Auto conversion       I to I.VAR, F.READ to CACHE.READ
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.PARAMETER


INITIALISE:
*----------
*

    F.TELLER.PARAMETER = ''
    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    CALL OPF(FN.TELLER.PARAMETER, F.TELLER.PARAMETER)

    R.TT.TP = ''
    TT.TP.ID = ''
    TT.TP.ERR = ''
    VAULTS.IDS = ''
    TT.TP.ID.LIST = ''
    VAULTS.ID.LIST = ''
    CMP.VAULT.LIST = ''
    VAULT.ID = ''


SEL.RECS:
*--------
*

    SEL.CMD = "SELECT ":FN.TELLER.PARAMETER
    SEL.CMD := " WITH @ID NE ":ID.COMPANY
    CALL EB.READLIST(SEL.CMD, TT.TP.ID.LIST, "", "", "")


PROCESS:
*-------
*
    LOOP
        REMOVE TT.TP.ID FROM TT.TP.ID.LIST SETTING TP.POS
    WHILE TT.TP.ID : TP.POS
        CALL CACHE.READ(FN.TELLER.PARAMETER, TT.TP.ID, R.TT.TP, TT.TP.ERR) ;*R22 Auto conversion

        IF NOT(TT.TP.ERR) THEN
            GOSUB FILTER.VAULTS.IDS
        END

    REPEAT

RETURN


FILTER.VAULTS.IDS:
*-----------------
*
    CMP.VAULT.LIST = '' ;  CMP.VAULT.LIST = R.TT.TP<TT.PAR.VAULT.ID>
    CNT = DCOUNT(CMP.VAULT.LIST, @VM)


    FOR I.VAR = 1 TO CNT

        VAULT.ID = R.TT.TP<TT.PAR.VAULT.ID><1,I.VAR>
        VAULT.DESC = R.TT.TP<TT.PAR.VAULT.DESC><1,I.VAR>

        IF VAULT.ID NE '0099' THEN
            VAULTS.ID.LIST<-1> = VAULT.ID:'#': VAULT.DESC
        END

    NEXT I.VAR

RETURN
END
