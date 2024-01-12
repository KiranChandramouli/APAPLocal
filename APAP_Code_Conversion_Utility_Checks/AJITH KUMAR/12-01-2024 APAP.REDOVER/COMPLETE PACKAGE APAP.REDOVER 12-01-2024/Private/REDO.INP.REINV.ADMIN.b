* @ValidationCode : Mjo0Nzg3MjMxNjM6Q3AxMjUyOjE3MDM2NTE4NDAxMTE6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Dec 2023 10:07:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.REINV.ADMIN

*-------------------------------------------
* DESCRIPTION: This routine is to update the REDO.TEMP.VERSION.IDS.


*----------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 14-Jul-2011 H Ganesh PACS00072695 - N.11 Initial Draft.
* 15-Mar-2013 Vignesh Kumaar R PACS00251345 To include FT records posted through FUNDS.TRANSFER,CHQ.GOVT.WITH.TAX
*----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          FM TO @FM
*06-04-2023       Samaran T              R22 Manual Code Conversion        No Changes
* 27-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TEMP.VERSION.IDS
    $USING EB.LocalReferences

    GOSUB INIT
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
    F.REDO.TEMP.VERSION.IDS = ''
    CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    LOC.REF.APPLICATION = "FUNDS.TRANSFER"
    LOC.REF.FIELDS = 'L.FT.AZ.TXN.REF'
    LOC.REF.POS = ''
*CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,POS.L.FT.AZ.TXN.REF)
    EB.LocalReferences.GetLocRef(LOC.REF.APPLICATION,LOC.REF.FIELDS,POS.L.FT.AZ.TXN.REF);*R22 MANUAL CODE CONVERSION


* Fix for PACS00251345 [To include FT records posted through FUNDS.TRANSFER,CHQ.GOVT.WITH.TAX]

    Y.VERSION.ID.LIST = 'FUNDS.TRANSFER,CHQ.OTHERS.DEPOSIT':@FM:'FUNDS.TRANSFER,CHQ.NO.TAX.DEPOSIT':@FM:'FUNDS.TRANSFER,CHQ.GOVT.WITH.TAX'

    LOOP
        REMOVE Y.VERSION.ID FROM Y.VERSION.ID.LIST SETTING VERSION.POST
    WHILE Y.VERSION.ID:Y.VERSION.ID.LIST

        CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.VERSION.ID,R.VERSION.IDS,F.REDO.TEMP.VERSION.IDS,VERSION.ERR)
        Y.FT.ID = R.NEW(FT.LOCAL.REF)<1,POS.L.FT.AZ.TXN.REF>

        LOCATE Y.FT.ID IN R.VERSION.IDS<REDO.TEM.AUT.TXN.ID,1> SETTING POS.ID THEN

            GOSUB WRITE.AUTH
            EXIT
        END

    REPEAT

* End of Fix

RETURN
*-----------------------------------------------------------------------------
WRITE.AUTH:
*-----------------------------------------------------------------------------

    DEL R.VERSION.IDS<REDO.TEM.AUT.TXN.ID,POS.ID>
    DEL R.VERSION.IDS<REDO.TEM.PROCESS.DATE,POS.ID>
    R.VERSION.IDS<REDO.TEM.REV.TXN.ID,POS.ID> = Y.FT.ID
    R.VERSION.IDS<REDO.TEM.REV.TXN.DATE,POS.ID> = TODAY
    CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.VERSION.ID,R.VERSION.IDS)

    Y.VER.ID = 'FUNDS.TRANSFER,CHQ.REV.AUTH'
* CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.VER.ID,R.VERSION.IDS,F.REDO.TEMP.VERSION.IDS,VERSION.ERR)
    CALL F.READU(FN.REDO.TEMP.VERSION.IDS,Y.VER.ID,R.VERSION.IDS,F.REDO.TEMP.VERSION.IDS,VERSION.ERR,'');*R22 MANUAL CODE CONVERSION
    R.VERSION.IDS<REDO.TEM.REV.TXN.ID,-1> = ID.NEW
    R.VERSION.IDS<REDO.TEM.REV.TXN.DATE,-1> = TODAY
    CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.VER.ID,R.VERSION.IDS)

RETURN
*-----------------------------------------------------------------------------
END
