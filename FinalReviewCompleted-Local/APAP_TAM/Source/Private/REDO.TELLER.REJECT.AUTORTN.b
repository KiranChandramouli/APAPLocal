* @ValidationCode : Mjo2MzMyODQ5NzU6Q3AxMjUyOjE2ODMwMTgwOTYwNjk6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 14:31:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TELLER.REJECT.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.TELLER.REJECT.AUTORTN
* ODR NO      : ODR-2009-10-0322
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.TELLER.PROCESS to
* default the value for the REDO.TELLER.REJECT application from REDO.TELLER.PROCESS
* It is AUTOM NEW CONTENT routine


 
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.TELLER.REJECT,CREATE
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*15.05.2010  S SUDHARSANAN   ODR-2009-10-0322   INITIAL CREATION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.REDO.TELLER.REJECT


    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------


    FN.REDO.TELLER.PROCESS = 'F.REDO.TELLER.PROCESS'
    F.REDO.TELLER.PROCESS = ''
    CALL OPF(FN.REDO.TELLER.PROCESS,F.REDO.TELLER.PROCESS)
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.DATA = ""
    CALL BUILD.USER.VARIABLES(Y.DATA)
    Y.REDO.TELLER.PROCESS.ID=FIELD(Y.DATA,"*",2)
    CALL F.READ(FN.REDO.TELLER.PROCESS,Y.REDO.TELLER.PROCESS.ID,R.REDO.TELLER.PROCESS,F.REDO.TELLER.PROCESS,PRO.ERR)

    Y.CONCEPT =R.REDO.TELLER.PROCESS<TEL.PRO.CONCEPT>
    Y.CURRENCY =R.REDO.TELLER.PROCESS<TEL.PRO.CURRENCY>
    Y.CLIENT.ID =R.REDO.TELLER.PROCESS<TEL.PRO.CLIENT.ID>
    Y.CLIENT.NAME =R.REDO.TELLER.PROCESS<TEL.PRO.CLIENT.NAME>
    Y.AMOUNT =R.REDO.TELLER.PROCESS<TEL.PRO.AMOUNT>
    Y.GROUP =R.REDO.TELLER.PROCESS<TEL.PRO.GROUP>
    Y.SUB.GROUP =R.REDO.TELLER.PROCESS<TEL.PRO.SUB.GROUP>
    Y.CATEGORY=R.REDO.TELLER.PROCESS<TEL.PRO.CATEGORY>
    Y.PAYMENT.TYPE=R.REDO.TELLER.PROCESS<TEL.PRO.PAYMENT.TYPE>

    R.NEW(TEL.REJ.AMOUNT)=Y.AMOUNT
    R.NEW(TEL.REJ.CURRENCY)=Y.CURRENCY
    R.NEW(TEL.REJ.CLIENT.ID)=Y.CLIENT.ID
    R.NEW(TEL.REJ.CLIENT.NAME)=Y.CLIENT.NAME
    R.NEW(TEL.REJ.PAYMENT.TYPE)=Y.PAYMENT.TYPE
    R.NEW(TEL.REJ.CATEGORY)=Y.CATEGORY
    R.NEW(TEL.REJ.GROUP)=Y.GROUP
    R.NEW(TEL.REJ.CONCEPT)=Y.CONCEPT
    R.NEW(TEL.REJ.SUB.GROUP)=Y.SUB.GROUP

RETURN

END
