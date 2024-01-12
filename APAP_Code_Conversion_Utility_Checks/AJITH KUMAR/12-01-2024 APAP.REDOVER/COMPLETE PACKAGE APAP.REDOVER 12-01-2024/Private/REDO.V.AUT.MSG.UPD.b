* @ValidationCode : Mjo3NDg4NTExMzY6Q3AxMjUyOjE3MDM3NDI2MjQxMjY6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Dec 2023 11:20:24
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
SUBROUTINE REDO.V.AUT.MSG.UPD
*-----------------------------------------------------------------------------

*------------
*DESCRIPTION:
*------------
*This routine is attached as a authorization routine for CUSTOMER application
*This rouitne will post ofs message to create EB.SECURE.MESSAGE when ACTDATOS
*type record is not received for the customer and it will post ofs message to
*reverse record in EB.SECURE.MESSAGE

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference                     Description
* 10-FEB-2010        Prabhu.N       ODR-2009-12-0279             Initial Creation
*06-04-2023       Conversion Tool   R22 Auto Code conversion         No Changes
*06-04-2023       Samaran T         R22 Manual Code Conversion       No Changes
* 28-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.SECURE.MESSAGE
    $INSERT I_F.REDO.T.MSG.DET
    $INSERT I_F.REDO.MSG.PARAMETER
    $INSERT I_F.CUST.DOCUMENT
    GOSUB INIT
    GOSUB PROCESS
RETURN
*----
INIT:
*----
    FN.REDO.T.MSG.DET='F.REDO.T.MSG.DET'
    F.REDO.T.MSG.DET=''
    CALL OPF(FN.REDO.T.MSG.DET,F.REDO.T.MSG.DET)

    FN.MSG.PARAMETER='F.REDO.MSG.PARAMETER'
    F.MSG.PARAMETER=''
    CALL OPF(FN.MSG.PARAMETER,F.MSG.PARAMETER)


    FN.CUST.DOCUMENT.INAU='F.CUST.DOCUMENT$NAU'
    F.CUST.DOCUMENT.INAU=''
    CALL OPF(FN.CUST.DOCUMENT.INAU,F.CUST.DOCUMENT.INAU)

    Y.DOCUMENT.ID=ID.NEW:"*ACTDATOS"
    CALL F.READ(FN.CUST.DOCUMENT.INAU,Y.DOCUMENT.ID,R.CUST.DOCUMENT,F.CUST.DOCUMENT.INAU,DOC.ERR)
    Y.DOCUMENT.STATUS=R.CUST.DOCUMENT<CUS.DOC.STATUS>


RETURN
*--------
PROCESS:
*---------


*---------------------------------------------------------------------------------------------------
*  Checks wheteher EB.SECURE.MESSAGE  is alredy created or not when ACTDATOS/CUS*100 is not received
*  If  not created then POSTS ofs message  to create new EB.SECURE.MESSAGE Record
*---------------------------------------------------------------------------------------------------
    IF Y.DOCUMENT.STATUS EQ 2 THEN
        CALL F.READ(FN.REDO.T.MSG.DET,ID.NEW,R.MSG.DET,F.REDO.T.MSG.DET,ERR)
        IF R.MSG.DET EQ '' THEN
            ID.VAR='SYSTEM' ;*R22 MANUAL CODE CONVERSION
            CALL CACHE.READ(FN.MSG.PARAMETER,ID.VAR,R.MSG.PARM,ERR)
            R.SECURE.MSG=''
            R.SECURE.MSG<EB.SM.TO.CUSTOMER> =ID.NEW
            R.SECURE.MSG<EB.SM.SUBJECT>=R.MSG.PARM<MG.SUBJECT>
            R.SECURE.MSG<EB.SM.MESSAGE>=R.MSG.PARM<MG.TEXT>
            TRANS.FUNC.VAL = 'I'
            APPLICATION.ID = ''
            APPLICATION.NAME.VERSION = 'EB.SECURE.MESSAGE,MSG.INPUT'
            GOSUB GEN.OFS
        END
    END

*-----------------------------------------------------------------------------------------------
*  Checks ACTDATOS/CUS*100 is received for the customer and if received then delete the entry in
*  REDO.T.MSG.DET for the customer and post OFS message to reverse EB.SECURE.MESSAGE
*------------------------------------------------------------------------------------------------
    IF Y.DOCUMENT.STATUS EQ 1 THEN
* CALL F.READ(FN.REDO.T.MSG.DET,ID.NEW,R.MSG.DET,F.REDO.T.MSG.DET,ERR)
        CALL F.READU(FN.REDO.T.MSG.DET,ID.NEW,R.MSG.DET,F.REDO.T.MSG.DET,ERR,'');*R22 MANUAL CODE CONVERSION
        IF R.MSG.DET NE '' THEN
            R.SECURE.MSG=''
            TRANS.FUNC.VAL='R'
            APPLICATION.NAME.VERSION='EB.SECURE.MESSAGE,MSG.REV'
            APPLICATION.ID = R.MSG.DET
            GOSUB GEN.OFS
            CALL F.DELETE(FN.REDO.T.MSG.DET,ID.NEW)
        END
    END
RETURN
*-------
GEN.OFS:
*--------
    OFS.SOURCE.ID = 'REDO.MSG.UPD'
    APPLICATION.NAME = 'EB.SECURE.MESSAGE'
    TRANS.OPER.VAL = 'PROCESS'
    NO.AUT = ''
    OFS.MSG.ID = ''
    OFS.REQ.MSG = ''
    CALL OFS.BUILD.RECORD(APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT,APPLICATION.ID,R.SECURE.MSG,OFS.REQ.MSG)
    CALL OFS.POST.MESSAGE(OFS.REQ.MSG,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
RETURN
END
