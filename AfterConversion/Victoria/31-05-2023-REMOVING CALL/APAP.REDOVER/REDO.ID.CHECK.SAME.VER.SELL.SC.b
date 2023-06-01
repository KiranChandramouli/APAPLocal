* @ValidationCode : MjoxMjI4Mzc5NTc0OkNwMTI1MjoxNjgyNDEyMzI5NTA5OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:29
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.ID.CHECK.SAME.VER.SELL.SC
    
*MODIFICATION HISTORY:
*-------------------------------------------------------------------------------

* DATE          WHO          REFERENCE      DESCRIPTION

* 06-04-2023    CONVERSION TOOL     AUTO R22 CODE CONVERSION     NO CHANGE
* 06-04-2023    MUTHUKUMAR M        MANUAL R22 CODE CONVERSION   NO CHANGE

*-------------------------------------------------------------------------------
    

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.REDO.SC.MM.VERSION.PARAM


    WAPP.LST = "SEC.TRADE"
    WCAMPO    = "L.NUM.OP.CEN"
    YPOS=''
    CALL MULTI.GET.LOC.REF(WAPP.LST,WCAMPO,YPOS)
    WPOSL1    = YPOS<1,1>


    IF NOT( R.OLD(SC.SBS.CURR.NO) ) THEN
        T.LOCREF<WPOSL1, 7> = 'NOINPUT'
    END ELSE
        T.LOCREF<WPOSL1, 7> = ''
    END

    IF R.NEW(SC.SBS.RECORD.STATUS) NE '' THEN
        Y.BUY.VAL = R.NEW(SC.SBS.CUST.TRANS.CODE)
        IF Y.BUY.VAL NE 'SEL' THEN          ;* updated as SEL from SELL
            E = 'EB-VERSION.DIFFERS'
            CALL STORE.END.ERROR
        END
    END
RETURN

END
