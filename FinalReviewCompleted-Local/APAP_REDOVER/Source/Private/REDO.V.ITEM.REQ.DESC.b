* @ValidationCode : Mjo4MTQ5NzE5MjA6Q3AxMjUyOjE2ODEzMDAxMzkyNjA6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 17:18:59
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
SUBROUTINE REDO.V.ITEM.REQ.DESC
*-----------------------------------------------------------------------------
* Description:
* This routine will be attached to the versions as
* a validation routine
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.ITEM.REQ.DESC
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE                      DESCRIPTION
* 12.04.2010  MARIMUTHU S      ODR-2009-11-0200                INITIAL CREATION
*12-04-2023  Conversion Tool   R22 Auto Code conversion       FM TO @FM VM TO @VM
*12-04-2023    Samaran T       R22 Manual Code conversion         No Changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.H.ITEM.DETAILS
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.REDO.H.ORDER.DETAILS = 'F.REDO.H.ORDER.DETAILS'
    F.REDO.H.ORDER.DETAILS = ''
    CALL OPF(FN.REDO.H.ORDER.DETAILS,F.REDO.H.ORDER.DETAILS)

    FN.REDO.H.ITEM.DETAILS = 'F.REDO.H.ITEM.DETAILS'
    F.REDO.H.ITEM.DETAILS = ''
    CALL OPF(FN.REDO.H.ITEM.DETAILS,F.REDO.H.ITEM.DETAILS)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.DESC = COMI
    SEL.CMD = 'SELECT ':FN.REDO.H.ITEM.DETAILS:' WITH DESCRIPTION EQ "':Y.DESC:'"'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,ITEM.ERR)
    SEL.LIST = SORT(SEL.LIST)
    Y.ITEM.ID = FIELD(SEL.LIST,@FM,1)
    CALL F.READ(FN.REDO.H.ITEM.DETAILS,Y.ITEM.ID,R.REDO.H.ITEM.DETAILS,F.REDO.H.ITEM.DETAILS,IT.DET.ERR)

    Y.DESCRIPTIONS = R.REDO.H.ITEM.DETAILS<IT.DT.DESCRIPTION>
    Y.DESCRIPTIONS = CHANGE(Y.DESCRIPTIONS,@VM,@FM)


    LOCATE Y.DESC IN Y.DESCRIPTIONS SETTING POS THEN
        Y.SUPPLY.CODE = R.REDO.H.ITEM.DETAILS<IT.DT.SUPPLY.CODE,POS>
        R.NEW(RE.ORD.ITEM.CODE) = Y.SUPPLY.CODE
    END

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
END
