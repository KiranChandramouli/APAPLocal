* @ValidationCode : MjoxMDIzNTI3MDIzOkNwMTI1MjoxNjgxNzM0MzkwMTYyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 17:56:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.TFS.GET.CONCEPT
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Prabhu N
* PROGRAM NAME: REDO.V.VAL.TFS.GET.CONCEPT
* ODR NO      : ODR-2009-10-0322
*  HD NO      : HD1103429
*----------------------------------------------------------------------
*DESCRIPTION: This routine gets the value from comi(TFS transaction code)
*Based on language of the user it will populate the description of TFS transaction
*in the concept field of REDO.TFS.PROCESS application
*It will populate the description which can be edited by user

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.TFS.PROCESS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*08-FEB-2011  Prabhu N        HD1103429        INITIAL CREATION
*----------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TFS.PROCESS
    $INSERT I_F.TFS.TRANSACTION
    $INSERT I_F.USER
    IF VAL.TEXT THEN
        RETURN
    END
    GOSUB INIT
RETURN
*----
INIT:
*----

    FN.TFS.TRANSACTION='F.TFS.TRANSACTION'
    F.TFS.TRANSACTION=''
    CALL OPF(FN.TFS.TRANSACTION,F.TFS.TRANSACTION)

    CALL F.READ(FN.TFS.TRANSACTION,COMI,R.TFS.TRANSACTION,F.TFS.TRANSACTION,TEL.TRA.ERR)
    Y.LANGUAGE=R.USER<EB.USE.LANGUAGE>
    R.NEW(TFS.PRO.CONCEPT)<1,AV>= R.TFS.TRANSACTION<TFS.TXN.DESCRIPTION><1,Y.LANGUAGE>
RETURN
END
