SUBROUTINE  REDO.APAP.H.PARAMETER.VALIDATE
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.APAP.H.PARAMETER.VALIDATE
*Date              : 09.12.2010
*Description       : This routine is to validate the REDO.APAP.H.PARAMETER table
*
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date               Name                   Reference            Version
* -------            ----                   ----------           --------
* 26-Nov-2018        Vignesh Kumaar M R     CI#2795720           BRD001 - FAST FUNDS SERVICES
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.H.PARAMETER

    IF R.NEW(PARAM.OCT.FF.ACCT) NE '' THEN

        GET.OCT.FF.ACCT.CNT = DCOUNT(R.NEW(PARAM.OCT.FF.ACCT),@VM)
        GET.OCT.FF.DOP.ACCT = R.NEW(PARAM.OCT.DOP.ACCT)
        GET.OCT.FF.USD.ACCT = R.NEW(PARAM.OCT.USD.ACCT)

        I.VAR = 1

        LOOP
        WHILE I.VAR LE GET.OCT.FF.ACCT.CNT
            IF GET.OCT.FF.DOP.ACCT<1,I.VAR> EQ '' THEN
                AF = PARAM.OCT.DOP.ACCT
                AV = I.VAR
                ETEXT = "EB-INPUT.MISSING"
                CALL STORE.END.ERROR
            END

            IF GET.OCT.FF.USD.ACCT<1,I.VAR> EQ '' THEN
                AF = PARAM.OCT.USD.ACCT
                AV = I.VAR
                ETEXT = "EB-INPUT.MISSING"
                CALL STORE.END.ERROR
            END
            I.VAR += 1
        REPEAT

    END

RETURN
