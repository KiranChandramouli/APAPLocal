$PACKAGE APAP.TAM
* Version 2 02/06/00  GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.NOSTRO.ACCT.LIST.VALIDATE
*-----------------------------------------------------------------------------
*** Template FOR validation routines
* @author youremail@temenos.com
* @stereotype validator
* @package infra.eb
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*DEVELOPMENT DETAILS:
*~~~~~~~~~~~~~~~~~~~~
*
*   Date               who           Reference            Description
*   ~~~~               ~~~           ~~~~~~~~~            ~~~~~~~~~~~
* 22-APR-2010     SHANKAR RAJU     ODR-2010-03-0447     Initial Creation
*-----------------------------------------------------------------------------
*** <region name= Main section>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.NOSTRO.ACCT.LIST
    $INSERT I_F.ACCOUNT

    GOSUB INITIALISE
    GOSUB PROCESS.MESSAGE
RETURN
*** </region>
*-----------------------------------------------------------------------------
VALIDATE:
*-------
    Y.ACCOUNT.ID = ID.NEW

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCT)
    R.NEW(NOSTRO.ACCT.LIST.ACCOUNT.NAME) = R.ACCOUNT<AC.ACCOUNT.TITLE.1>
    R.NEW(NOSTRO.ACCT.LIST.CURRENCY) = R.ACCOUNT<AC.CURRENCY>
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*---------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*-----------------------------------------------------------------------------
PROCESS.MESSAGE:
    BEGIN CASE
        CASE MESSAGE EQ ''          ;* Only during commit
            BEGIN CASE
                CASE V$FUNCTION EQ 'D'
                    GOSUB VALIDATE.DELETE
                CASE V$FUNCTION EQ 'R'
                    GOSUB VALIDATE.REVERSE
                CASE OTHERWISE  ;* The real VALIDATE
                    GOSUB VALIDATE
            END CASE
        CASE MESSAGE EQ 'AUT' OR MESSAGE EQ 'VER'       ;* During authorisation and verification
            GOSUB VALIDATE.AUTHORISATION
    END CASE
RETURN
*-----------------------------------------------------------------------------
VALIDATE.DELETE:

RETURN
*-----------------------------------------------------------------------------
VALIDATE.REVERSE:

RETURN
*-----------------------------------------------------------------------------
VALIDATE.AUTHORISATION:

RETURN
*-----------------------------------------------------------------------------
END
