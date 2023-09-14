* @ValidationCode : MjotODE1OTg2NTk2OkNwMTI1MjoxNjgyNDEyMzU1MzczOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:55
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
SUBROUTINE REDO.V.UPD.LATAM.CARD.SERIES
*-----------------------------------------------------------------------------
* DESCRIPTION
*-----------
* This is a routine will be called by CARD.ISSUE,SBP during authorization
*
*-------------------------------------------------------------------------------------
* This subroutine caters the following task :-
* This routine will update the LATAM.CARD.ORDER application when a changes made is CARD.ISSUE start no
* table through OFS
*-----------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : -na-
* OUT    : -na-
* Dependencies
* ------------
*
*-------------------------------------------------------------------------------------------
* Revision History
*-------------------------
*    Date             Who               Reference       Description
*  20-Apr-2011   Balagurunathan           TDN4            Initial Draft
*Modification history
*Date                Who               Reference                  Description
*18-04-2023      conversion tool     R22 Auto code conversion     No changes
*18-04-2023      Mohanraj R          R22 Manual code conversion   No changes___________________________________________________________________________________________

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CARD.ISSUE
    $INSERT I_F.LATAM.CARD.ORDER

    FN.LATAM.CARD.ORDER='F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER=''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

    CALL F.READU(FN.LATAM.CARD.ORDER,ID.NEW,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,ERR,'P')

    R.LATAM.CARD.ORDER<CARD.IS.CARD.START.NO>=R.NEW(CARD.IS.CARD.START.NO)

    CALL F.WRITE(FN.LATAM.CARD.ORDER,ID.NEW,R.LATAM.CARD.ORDER)

RETURN

END
